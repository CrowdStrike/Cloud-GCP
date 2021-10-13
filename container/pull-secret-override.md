# Method to override GCR pull secret for injector

Populate $GCP_PROJECT_ID variable

```
    GCP_PROJECT_ID=$(gcloud config get-value core/project)
```

Create new GCP service account

```
    if ! gcloud iam service-accounts describe falcon-container-injector@$GCP_PROJECT_ID.iam.gserviceaccount.com > /dev/null 2>&1 ; then
        gcloud iam service-accounts create falcon-container-injector
    fi
```

Grant the newly create service account permissions to pull GCP images

```
    gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
        --member serviceAccount:falcon-container-injector@$GCP_PROJECT_ID.iam.gserviceaccount.com \
        --role roles/storage.objectViewer
```

Generate a new key for the service account
```
    gcloud iam service-accounts keys create \
        --iam-account "falcon-container-injector@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
        key.json
```

Generate Falcon Container Pull secret
```
    cp ~/.docker/config.json{,.bac}
    cat  key.json | docker login --username "_json_key" --password-stdin https://gcr.io
    IMAGE_PULL_TOKEN=$(cat ~/.docker/config.json | base64 -w 0)
    cp ~/.docker/config.json{.bac,}
```
