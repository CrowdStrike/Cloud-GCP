# GCP Secret Manager Terraform
resource "google_secret_manager_secret" "bucket_scan_client_id" {
  project   = var.project_id
  secret_id = "${var.unique_id}_${var.sm_param_client_id}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "bucket_scan_client_secret" {
  project   = var.project_id
  secret_id = "${var.unique_id}_${var.sm_param_client_secret}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version_client_id" {
  secret      = google_secret_manager_secret.bucket_scan_client_id.id
  secret_data = var.falcon_client_id
}

resource "google_secret_manager_secret_version" "secret_version_client_secret" {
  secret      = google_secret_manager_secret.bucket_scan_client_secret.id
  secret_data = var.falcon_client_secret
}
