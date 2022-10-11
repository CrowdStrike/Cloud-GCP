"""CrowdStrike GCP Cloud Storage Bucket Protection with QuickScan.

Based on the work of @jshcodes w/ s3-bucket-protection

Creation date: 10.06.22 - carlos.matos@CrowdStrike
"""
import io
import os
import time
import logging
import urllib.parse
import json
import google.cloud.logging
from google.cloud import storage
# FalconPy SDK - Auth, Sample Uploads and Quick Scan
from falconpy import OAuth2, SampleUploads, QuickScan  # pylint: disable=E0401

# Maximum file size for scan (35mb)
MAX_FILE_SIZE = 36700160

# GCP Logging Client
gcp_logging_client = google.cloud.logging.Client()
# Configure GCP Logging to utilize standard python logging
gcp_logging_client.setup_logging()
log = logging.getLogger()
log.setLevel(logging.INFO)

# GCP Storage handler
gcs = storage.Client()

# Current region
# region = os.environ.get('AWS_REGION')

# Mitigate threats?
MITIGATE = bool(json.loads(os.environ.get("MITIGATE_THREATS", "TRUE").lower()))

# Base URL
BASE_URL = os.environ.get("BASE_URL", "https://api.crowdstrike.com")

# Grab our Falcon API creds from the environment if they exist
try:
    client_id = os.environ["FALCON_CLIENT_ID"]
except KeyError:
    raise SystemExit("FALCON_CLIENT_ID environment variable not set")

try:
    client_secret = os.environ["FALCON_CLIENT_SECRET"]
except KeyError:
    raise SystemExit("FALCON_CLIENT_SECRET environment variable not set")

# Authenticate to the CrowdStrike Falcon API
auth = OAuth2(creds={
            "client_id": client_id,
            "client_secret": client_secret
            }, base_url=BASE_URL)

# Connect to the Samples Sandbox API
Samples = SampleUploads(auth_object=auth)
# Connect to the Quick Scan API
Scanner = QuickScan(auth_object=auth)


# Main routine
def bucket_scan(event, _):
    """GCP Cloud Functions entry point"""
    bucket_name = event["bucket"]
    bucket = gcs.get_bucket(bucket_name)
    file_name = urllib.parse.unquote_plus(event["name"], encoding="utf-8")
    upload_file_size = int(event["size"])
    if upload_file_size < MAX_FILE_SIZE:
        # Get the file from GCP
        blob = bucket.blob(file_name)
        blob_data = blob.download_as_bytes()
        # Upload the file to the CrowdStrike Falcon Sandbox
        response = Samples.upload_sample(
            file_name=file_name,
            file_data=io.BytesIO(blob_data),
        )
        if response["status_code"] > 201:
            raise SystemExit(f"Error uploading object {file_name} from bucket {bucket_name} to Falcon X Sandbox. "
                  "Make sure your API key has the Sample Uploads permission.")
        else:
            log.info("File uploaded to CrowdStrike Falcon Sandbox.")

        # Quick Scan
        try:
            # Uploaded file unique identifier
            upload_sha = response["body"]["resources"][0]["sha256"]
            # Scan request ID, generated when the request for the scan is made
            scan_id = Scanner.scan_samples(body={"samples": [upload_sha]})["body"]["resources"][0]
            scanning = True
            # Loop until we get a result or the function times out
            while scanning:
                # Retrieve our scan using our scan ID
                scan_results = Scanner.get_scans(ids=scan_id)
                try:
                    if scan_results["body"]["resources"][0]["status"] == "done":
                        # Scan is complete, retrieve our results (there will be only one)
                        result = scan_results["body"]["resources"][0]["samples"][0]
                        # and break out of the loop
                        scanning = False
                    else:
                        # Not done yet, sleep for a bit
                        time.sleep(3)
                except IndexError:
                    # Results aren't populated yet, skip
                    pass
            if result["sha256"] == upload_sha:
                if "no specific threat" in result["verdict"]:
                    # File is clean
                    scan_msg = f"No threat found in {file_name}"
                    log.info(scan_msg)
                elif "unknown" in result["verdict"]:
                    if "error" in result:
                        # Error occurred
                        scan_msg = f"Scan error for {file_name}: {result['error']}"
                        log.info(scan_msg)
                    else:
                        # Undertermined scan failure
                        scan_msg = f"Unable to scan {file_name}"
                        log.info(scan_msg)
                elif "malware" in result["verdict"]:
                    # Mitigation would trigger from here
                    scan_msg = f"Verdict for {file_name}: {result['verdict']}"
                    log.warning(scan_msg)
                    threat_removed = False
                    if MITIGATE:
                        # Remove the threat
                        try:
                            blob.delete()
                            threat_removed = True
                        except Exception as err:
                            log.warning("Unable to remove threat %s from bucket %s", file_name, bucket_name)
                            print(f"{err}")
                    else:
                        # Mitigation is disabled. Complain about this in the log.
                        log.warning("Threat discovered (%s). Mitigation disabled, threat persists in %s bucket.",
                                    file_name,
                                    bucket_name
                                    )

                    if threat_removed:
                        log.info("Threat %s removed from bucket %s", file_name, bucket_name)
                else:
                    # Unrecognized response
                    scan_msg = f"Unrecognized response ({result['verdict']}) received from API for {file_name}."
                    log.info(scan_msg)

            # Clean up the artifact in the sandbox
            response = Samples.delete_sample(ids=upload_sha)
            if response["status_code"] > 201:
                log.warning("Could not remove sample (%s) from sandbox.", file_name)

            return scan_msg
        except Exception as err:
            print(err)
            print(f"Error getting object {file_name} from bucket {bucket_name}. "
                  "Make sure they exist and your bucket is in the same region as this function.")
            raise err

    else:
        msg = f"File ({file_name}) exceeds maximum file scan size ({MAX_FILE_SIZE} bytes), skipped."
        log.warning(msg)
        return msg
