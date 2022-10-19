# GCP Cloud Storage Bucket Terraform
# Bucket used for uploading archived cloud function
resource "google_storage_bucket" "function_bucket" {
  name          = "${var.unique_id}-function"
  location      = var.region
  force_destroy = true
}
