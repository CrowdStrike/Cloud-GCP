# GCP Output Terraform
output "demo_bucket" {
  value = "gs://${google_storage_bucket.bucket.name}"
}
