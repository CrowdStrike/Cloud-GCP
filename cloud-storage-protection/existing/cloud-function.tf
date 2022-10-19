# GCP Cloud Function Terraform
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../cloud-function"
  output_path = "/tmp/${var.function_filename}"
}

# Add the Cloud Function to the bucket
resource "google_storage_bucket_object" "function" {
  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.source.output_path
}

# Create the Cloud Function w/ trigger
resource "google_cloudfunctions_function" "function" {
  name                  = "${var.unique_id}-${var.function_name}"
  description           = var.function_description
  available_memory_mb   = 256
  entry_point           = var.function_name
  runtime               = "python310"
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = data.google_storage_bucket.bucket.name
  }
  environment_variables = {
    "BASE_URL"         = "${var.base_url}"
    "MITIGATE_THREATS" = "${var.function_mitigate_threats}"
  }
  secret_environment_variables {
    key     = "FALCON_CLIENT_ID"
    secret  = google_secret_manager_secret.bucket_scan_client_id.secret_id
    version = "latest"
  }
  secret_environment_variables {
    key     = "FALCON_CLIENT_SECRET"
    secret  = google_secret_manager_secret.bucket_scan_client_secret.secret_id
    version = "latest"
  }
  depends_on            = [google_storage_bucket_object.function]
  service_account_email = google_service_account.sa.email
}
