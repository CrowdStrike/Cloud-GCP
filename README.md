<p align="center">
   <img src="https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/cs-logo.png" alt="CrowdStrike logo" width="500"/>
</p>

# GCP Integrations and Guides

## Security Command Center Integration

- **Falcon Integration Gateway**
  - [Marketplace Deployment Guide (GKE)](https://github.com/CrowdStrike/falcon-integration-gateway/blob/main/docs/listings/gke/UserGuide.md) | [Marketplace Listing](https://console.cloud.google.com/marketplace/product/crowdstrike-saas/falcon-integration-gateway-scc)
  - [Manual Deployment Guide (GKE)](https://github.com/CrowdStrike/falcon-integration-gateway/tree/main/docs/gke)

## CrowdStrike Sensor Automation

- **Deploy to GCE compute instances**
  - [Google VM Manager (OS Policy)](https://github.com/CrowdStrike/gcp-vm-manager-os-policy)
- **Deploy to GKE clusters**
  - [GKE Auto-protection](https://github.com/CrowdStrike/gcp-gke-protection)
  - [GKE Autopilot operator](https://github.com/CrowdStrike/falcon-operator/tree/main/docs/deployment/gke#gke-autopilot-configuration) (if not using auto-protection)
- **Deploy to Cloud Run applications**
  - [Patch container images](https://falcon.crowdstrike.com/login/?unilogin=true&next=/documentation/page/p6af9353/deploy-falcon-container-sensor-for-linux-on-google-cloud-run) (requires Falcon login)

## Cloud Storage Protection

- [Cloud Storage Bucket Protection with CrowdStrike QuickScan Pro API](https://github.com/crowdstrike/cloud-storage-protection)
