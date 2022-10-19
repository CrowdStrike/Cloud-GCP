![CrowdStrike](https://raw.github.com/CrowdStrike/Cloud-AWS/main/docs/img/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)

# On-demand GCP Cloud Storage bucket scanner
This example provides a stand-alone solution for scanning a Cloud Storage bucket before implementing protection.
While similar to the serverless function, this solution will only scan the bucket's _existing_ file contents.

> This example requires the `google-cloud-storage` and `crowdstrike-falconpy` (v0.8.7+) packages.

## Running the program
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2FCrowdStrike%2FCloud-GCP&cloudshell_workspace=cloud-storage-protection%2Fon-demand&cloudshell_tutorial=tutorial.md)

In order to run this solution, you will need:
+ Name of the target GCP Cloud Storage bucket
+ The Project ID associated with the target bucket
+ access to CrowdStrike API keys with the following scopes:
    | Service Collection | Scope |
    | :---- | :---- |
    | Quick Scan | __READ__, __WRITE__ |
    | Sample Uploads | __READ__, __WRITE__ |

### Execution syntax
The following command will execute the solution against the bucket you specify using default options.

```shell
python3 quickscan_target.py -k CROWDSTRIKE_API_KEY -s CROWDSTRIKE_API_SECRET -t gs://TARGET_BUCKET_NAME -p PROJECT_ID
```

A small command-line syntax help utility is available using the `-h` flag.

```shell
python3 quickscan_target.py -h
usage: Falcon Quick Scan [-h] [-l LOG_LEVEL] [-d CHECK_DELAY] [-b BATCH] -p PROJECT -t TARGET -k KEY -s SECRET

options:
  -h, --help            show this help message and exit
  -l LOG_LEVEL, --log-level LOG_LEVEL
                        Default log level (DEBUG, WARN, INFO, ERROR)
  -d CHECK_DELAY, --check-delay CHECK_DELAY
                        Delay between checks for scan results
  -b BATCH, --batch BATCH
                        The number of files to include in a volume to scan.
  -p PROJECT_ID, --project PROJECT_ID
                        Project ID the target bucket resides in
  -t TARGET, --target TARGET
                        Target folder or bucket to scan. Bucket must have 'gs://' prefix.
  -k KEY, --key KEY     CrowdStrike Falcon API KEY
  -s SECRET, --secret SECRET
                        CrowdStrike Falcon API SECRET
```

### Example output

```shell
2022-10-19 16:37:56,904 Quick Scan INFO Process startup complete, preparing to run scan
2022-10-19 16:37:59,962 Quick Scan INFO Assembling volumes from target bucket (test_sample_bucket) for submission
2022-10-19 16:38:02,078 Quick Scan INFO Uploaded README.md to 7f3efe17610c09e537c2494ad8d251ac300573f1c0f3ad4be500d650c9de5e7b
2022-10-19 16:38:03,934 Quick Scan INFO Uploaded README.md to 5252d7c5b99506a6a7b1fe8819485ca9847f7528476a4bb9f5d8b869a8c8726c
2022-10-19 16:38:06,563 Quick Scan INFO Uploaded youtube.png to 47af72b75c35839a381bf91f03f4d3b87eb4283af58ff4809e137eff2f06cb40
2022-10-19 16:38:08,479 Quick Scan INFO Uploaded .gitignore to ce2de08a3889bf39fcd4cdb43d9f83197fcf17ab5c5707b1c4490e9b6cede8f4
...
...
2022-10-19 16:38:50,466 Quick Scan INFO Unscannable file container/gke-implementation-guide.md: verdict unknown
2022-10-19 16:38:50,467 Quick Scan INFO Unscannable file container/pull-secret-override.md: verdict unknown
2022-10-19 16:38:50,467 Quick Scan INFO Verdict for safe1.bin: no specific threat
2022-10-19 16:38:50,467 Quick Scan INFO Unscannable file test.pdf: verdict unknown
...
...
2022-10-19 16:38:50,467 Quick Scan INFO Removing artifacts from Sandbox
2022-10-19 16:39:55,389 Quick Scan INFO Scan completed
```
