# GCP Output Terraform
output "demo_bucket" {
  value = "gs://${google_storage_bucket.bucket.name}"
}

output "demo_function_name" {
  value = google_cloudfunctions_function.function.name
}
