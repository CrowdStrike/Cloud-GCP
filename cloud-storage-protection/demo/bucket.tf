# GCP Cloud Storage Bucket Terraform
# Bucket used for uploading files to be scanned by the Cloud Function
resource "google_storage_bucket" "bucket" {
  name          = "${var.unique_id}-${var.bucket_name}"
  location      = var.region
  force_destroy = true
}

# Bucket used for uploading archived cloud function
resource "google_storage_bucket" "function_bucket" {
  name          = "${var.unique_id}-function"
  location      = var.region
  force_destroy = true
}
