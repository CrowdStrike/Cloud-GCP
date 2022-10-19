variable "unique_id" {
  description = "A unique identifier that is prepended to all created resource names"
  type        = string
  default     = "csexample"
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default = ""
}
variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}
variable "bucket_name" {
  description = "The name of the existing bucket to be protected"
  type        = string
  default     = ""
}
variable "function_execution_role_name" {
  description = "The name of the function execution IAM role"
  type        = string
  default     = "cs-protected-bucket-role"
}
variable "function_filename" {
  description = "The name of the archive to use for the function"
  type        = string
  default     = "quickscan-bucket.zip"
}
variable "function_name" {
  description = "The name used for the function"
  type        = string
  default     = "cs_bucket_protection"
}
variable "function_mitigate_threats" {
  description = "Remove malicious files from the bucket as they are discovered."
  type        = string
  default     = "TRUE"
}
variable "sm_param_client_id" {
  description = "Name of the Secret Manager parameter storing the API client ID"
  type        = string
  default     = "CS_FALCONX_SCAN_CLIENT_ID"
}
variable "sm_param_client_secret" {
  description = "Name of the Secret Manager parameter storing the API client secret"
  type        = string
  default     = "CS_FALCONX_SCAN_CLIENT_SECRET"
}
variable "falcon_client_id" {
  description = "The CrowdStrike Falcon API client ID"
  type        = string
  default     = ""
  sensitive   = true
}
variable "falcon_client_secret" {
  description = "The CrowdStrike Falcon API client secret"
  type        = string
  default     = ""
  sensitive   = true
}
variable "function_description" {
  description = "The description used for the function function"
  type        = string
  default     = "CrowdStrike CS bucket protection"
}
variable "iam_prefix" {
  description = "The prefix used for resources created within IAM"
  type        = string
  default     = "cs-bucket-protection"
}
variable "base_url" {
  description = "The Base URL for the CrowdStrike Cloud API"
  type        = string
  default     = "https://api.crowdstrike.com"
}
# Google Storage Bucket of Existing Bucket
data "google_storage_bucket" "bucket" {
  name = var.bucket_name
}
