#!/bin/bash
# This script is used to enable the required services for the Cloud Storage Protection
# demonstrations.
# Path: cloud-storage-protection/enable_services.sh
# Author: CrowdStrike

# List of GCP services required for the deployment
services=(
    secretmanager.googleapis.com
    cloudbuild.googleapis.com
    artifactregistry.googleapis.com
    eventarc.googleapis.com
    run.googleapis.com
    logging.googleapis.com
    pubsub.googleapis.com
    cloudfunctions.googleapis.com
    compute.googleapis.com
    storage.googleapis.com
    iam.googleapis.com
    cloudresourcemanager.googleapis.com
)

# Enable the services
for service in "${services[@]}"; do
    echo "Enabling GCP Service: ${service}"
    gcloud services enable "$service"
done
