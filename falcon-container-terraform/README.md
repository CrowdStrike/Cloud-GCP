# Terraform to demo Falcon Container Runtime Protection

[![Open in Cloud Shell](https://img.shields.io/badge/Google%20Cloud%20Shell-Clone-5391FE?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/crowdstrike/cloud-gcp&shellonly=true)

This terraform demo
 * creates single GKE cluster
 * creates single GCP instance for managing the cluster
 * enables container registry (GCR)
 * enables secrets manager
 * stores falcon credentials in GCP secrets manager
 * downloads Falcon Container sensor
 * pushes Falcon Container sensor to GCR
 * deploys Falcon Container sensor to the cluster
 * deploys vulnerable.example.com application

User then may
 * Show that container workload (vulnerable.example.com) appears in Falcon Console (under Hosts, or Containers Dashboard)
 * Visit vulnerable.example.com application and exploit it through the web interface
 * Show detections in Falcon Console

### Prerequsites
 - Get access to GCP
 - Have Containers enabled in Falcon console (CWP subscription)

### Usage

 - Open your GCP cloud shell: https://shell.cloud.google.com/?hl=en_US&fromcloudshell=true&show=terminal
 - Verify that your active GCP project in uppper left corner is correct
 - Verify that your identity in upper right corner is correct)
 - Paste the following to your cloud shell
```
bash -c 'source <(curl -s https://raw.githubusercontent.com/crowdstrike/cloud-gcp/falcon-container-terraform/main/run)'
```

### Tear Down

```
cd ~/falcon-container-terraform; terraform destroy
```

### Developer guide

 - Spin up the demo
   ```
   terraform init
   terraform apply
   ```

 - Get access to the admin VM that manages the GKE
   ```
   terraform output admin_access
   ```
   or directly
   ```
   $(terraform output admin_access | tr -d '"')
   ```

 - Get access to the vulnerable.example.command
   ```
   terraform output vulnerable-example-com
   ```

 - Tear down the demo
   ```
   terraform destroy
   ```

### Known limitations

 - This is early version. Please report or even fix issues.
