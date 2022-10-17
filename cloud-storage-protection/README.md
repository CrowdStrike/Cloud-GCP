![CrowdStrike](https://raw.github.com/CrowdStrike/Cloud-AWS/main/docs/img/cs-logo.png)

[![Twitter URL](https://img.shields.io/twitter/url?label=Follow%20%40CrowdStrike&style=social&url=https%3A%2F%2Ftwitter.com%2FCrowdStrike)](https://twitter.com/CrowdStrike)

# CrowdStrike Falcon GCP Cloud Storage Bucket Protection


## Demonstration
A demonstration has been developed for this integration. This demonstration creates a new bucket, implements GCP Cloud Storage Bucket Protection on that bucket, and then deploys an instance with several test scripts and sample files for testing the integration in a real environment.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fcarlosmmatos%2FCloud-GCP&cloudshell_git_branch=cloud-storage-protection&cloudshell_workspace=cloud-storage-protection&cloudshell_tutorial=demo%2Ftutorial.md)

For more details regard this demonstration, review the content located [here](demo).

## On-demand scanning
For scenarios where you either do not want to implement real-time protection, or where you are wanting to confirm the contents of a bucket before implementing protection, an on-demand scanning solution is provided as part of this integration.

This solution leverages the same APIs and logic that is implemented by the serverless handler that provides real-time protection.

The read more about this component, review the documentation located [here](on-demand).

## Deploying to an existing bucket
A helper routine is provided as part of this integration that assists with deploying protection to an existing bucket. This helper leverages Terraform, and can be started by executing the `existing.sh` script.

For more details about deploying protection to a pre-existing bucket, review the documentation located [here](existing).
