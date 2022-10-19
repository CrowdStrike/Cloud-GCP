# GCP IAM Terraform
resource "google_service_account" "sa" {
  account_id   = "${var.unique_id}-sa"
  display_name = "Service Account for CS Bucket Protection"
}

# Secret Manager IAM
resource "google_secret_manager_secret_iam_member" "client_id_member" {
  secret_id = google_secret_manager_secret.bucket_scan_client_id.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.sa.email}"
}
resource "google_secret_manager_secret_iam_member" "secret_member" {
  secret_id = google_secret_manager_secret.bucket_scan_client_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.sa.email}"
}

# Cloud Function IAM
resource "google_project_iam_member" "function_iam_binding" {
  project = var.project_id
  role    = "roles/cloudfunctions.serviceAgent"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Cloud Storage IAM
resource "google_project_iam_member" "bucket_iam_binding" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.sa.email}"
}
