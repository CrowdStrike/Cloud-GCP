# GCP Bucket Protection Demonstration
<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>
This demonstration leverages Terraform to provide a functional demonstration of this integration. All of the necessary resources for using this solution to protect a GCP Cloud Storage bucket are implemented for you as part of the environment configuration process, including sample files and command line helper scripts.

<walkthrough-project-setup></walkthrough-project-setup>

## Prerequisites
### GCP Services
In order to properly use this demo, run the following helper script to enable the appropriate GCP services:
```sh
./enable_services.sh
```

### CrowdStrike Falcon API Credentials
Assign the following scopes:
- Quick Scan - `READ`, `WRITE`
- Sample Uploads - `READ`,`WRITE`

> You will be asked to provide these credentials when the `demo.sh` script executes.

## Let's Get Started
Execute the following command to stand up the demonstration:

***Please note that the input for your credentials are hidden.***
```sh
./demo.sh up
```
You will be asked to provide your CrowdStrike API credentials.

If this is the first time you're executing the demonstration, Terraform will initialize the working folder after you submit these values. After this process completes, Terraform will begin to stand-up the environment.

It takes roughly 3 minutes to stand up the environment. When the environment is done, you will be presented with the message:
```terminal

╭━━━┳╮╱╱╭╮╱╱╱╭━━━┳━━━┳━╮╱╭┳━━━╮
┃╭━╮┃┃╱╱┃┃╱╱╱╰╮╭╮┃╭━╮┃┃╰╮┃┃╭━━╯
┃┃╱┃┃┃╱╱┃┃╱╱╱╱┃┃┃┃┃╱┃┃╭╮╰╯┃╰━━╮
┃╰━╯┃┃╱╭┫┃╱╭╮╱┃┃┃┃┃╱┃┃┃╰╮┃┃╭━━╯
┃╭━╮┃╰━╯┃╰━╯┃╭╯╰╯┃╰━╯┃┃╱┃┃┃╰━━╮
╰╯╱╰┻━━━┻━━━╯╰━━━┻━━━┻╯╱╰━┻━━━╯

Welcome to the CrowdStrike Falcon GCP Bucket Protection demo environment!

The name of your test bucket is gs://csexample-cs-protected-bucket.

There are test files in the /home/user/testfiles folder.
Use these to test the cloud-function trigger on bucket uploads.
NOTICE: Files labeled `malicious` are DANGEROUS!

Use the command `upload` to upload all of the test files to your demo bucket.

You can view the contents of your bucket with the command `list-bucket`.

Use the command `get-findings` to view any findings for your demo bucket.
```

Next, you'll use the helper commands to upload the sample files, and check for findings.

## Using the Demonstration
Now that your environment is stood up, and your cloud-shell is configured, you can use the helper commands to test functionality.

### List the objects in your bucket
Run the following command to list the contents of the demonstration bucket:
```sh
list-bucket
```

The bucket should be empty and return no results.

### Upload sample files
Run the following command to upload the entire contents of the `~/testfiles` folder to the demonstration bucket:
```sh
upload
```
The folder contains the following sample types:
+ 2 safe sample files
+ 2 malware sample files
+ 2 unscannable sample files

#### Example
```terminal
Uploading test files, please wait...
Copying file:///home/user/testfiles/malicious1.pdf [Content-Type=application/pdf]...
/ [1 files][310.6 KiB/310.6 KiB]
Operation completed over 1 objects/310.6 KiB.
Copying file:///home/user/testfiles/malicious2.doc [Content-Type=application/msword]...
/ [1 files][ 10.2 KiB/ 10.2 KiB]
Operation completed over 1 objects/10.2 KiB.
Copying file:///home/user/testfiles/safe1.bin [Content-Type=application/octet-stream]...
/ [1 files][ 38.8 KiB/ 38.8 KiB]
Operation completed over 1 objects/38.8 KiB.
Copying file:///home/user/testfiles/safe2.bin [Content-Type=application/octet-stream]...
/ [1 files][ 82.0 KiB/ 82.0 KiB]
Operation completed over 1 objects/82.0 KiB.
Copying file:///home/user/testfiles/unscannable1.png [Content-Type=image/png]...
/ [1 files][  1.1 MiB/  1.1 MiB]
Operation completed over 1 objects/1.1 MiB.
Copying file:///home/user/testfiles/unscannable2.jpg [Content-Type=image/jpeg]...
/ [1 files][255.2 KiB/255.2 KiB]
Operation completed over 1 objects/255.2 KiB.
Upload complete. Check Cloud Functions logs or use the get-findings command for scan results.
```

### Verify files were uploaded
Run the `list-bucket` helper command again to verify the files were uploaded to our demonstration bucket:
```sh
list-bucket
```

#### Example
```terminal
$ list-bucket
gs://csexample-cs-protected-bucket/safe1.bin
gs://csexample-cs-protected-bucket/safe2.bin
gs://csexample-cs-protected-bucket/unscannable1.png
gs://csexample-cs-protected-bucket/unscannable2.jpg
````
Next, you'll review the output from the Cloud Functions demonstration function.

## Review Cloud Function Logs
There are a few ways to view the status of the files uploaded to the demonstration bucket.

### Use the `get-findings` helper command
Run the following command to view any detected Malware threats:
```sh
get-findings
```

#### Example
```terminal
LOG: Threat malicious2.doc removed from bucket csexample-cs-protected-bucket
LOG: Verdict for malicious2.doc: malware
LOG: Threat malicious1.pdf removed from bucket csexample-cs-protected-bucket
LOG: Verdict for malicious1.pdf: malware
```

### Use the gcloud cli
Run the following command using the gcloud cli:
```sh
gcloud functions logs read csexample-cs_bucket_protection --min-log-level=info | grep log
```
This will give you more information surrounding a log entry.

#### Example
```terminal
LEVEL: I
NAME: csexample-cs_bucket_protection
EXECUTION_ID: oumcwnyi6hp1
TIME_UTC: 2022-10-17 18:44:42.272
LOG: Scan error for unscannable1.png: sample type not supported

LEVEL: I
NAME: csexample-cs_bucket_protection
EXECUTION_ID: je8w8jgn0ijl
TIME_UTC: 2022-10-17 18:44:41.681
LOG: Scan error for unscannable2.jpg: sample type not supported
```

### Use the Logging Dashboard
The quickest method for viewing the logs on the console is to:

Navigate to the Cloud Functions service page
-> Select the demo function
-> Select `LOGS`

Next, you'll tear down the demonstration to prevent your organization from yelling at you about runaway cloud costs ;)

## Tearing Down the Demonstration
To tear down the environment, and clean up any associated files, run the following command:
```sh
./demo.sh down
```
Once the environment has been destroyed and cleaned up, you will be provided the message:
```terminal
Destroy complete! Resources: 13 destroyed.

╭━━━┳━━━┳━━━┳━━━━┳━━━┳━━━┳╮╱╱╭┳━━━┳━━━╮
╰╮╭╮┃╭━━┫╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃╰╮╭╯┃╭━━┻╮╭╮┃
╱┃┃┃┃╰━━┫╰━━╋╯┃┃╰┫╰━╯┃┃╱┃┣╮╰╯╭┫╰━━╮┃┃┃┃
╱┃┃┃┃╭━━┻━━╮┃╱┃┃╱┃╭╮╭┫┃╱┃┃╰╮╭╯┃╭━━╯┃┃┃┃
╭╯╰╯┃╰━━┫╰━╯┃╱┃┃╱┃┃┃╰┫╰━╯┃╱┃┃╱┃╰━━┳╯╰╯┃
╰━━━┻━━━┻━━━╯╱╰╯╱╰╯╰━┻━━━╯╱╰╯╱╰━━━┻━━━╯
```

Finally, you'll be presented with modification options to this demonstration.

## Customize Demonstration
In the event that you would like to re-run this demonstration and use different values:
<walkthrough-editor-open-file
    filePath="demo/variables.tf">
    Edit the variable Terraform file
</walkthrough-editor-open-file>

Congratulations on completing this demonstration!
<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>
