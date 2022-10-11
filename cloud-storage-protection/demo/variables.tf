variable "unique_id" {
    description = "A unique identifier that is prepended to all created resource names"
    type = string
    default = "csexample"
}
variable "bucket_name" {
    description = "The name of the bucket that is created"
    type = string
    default = "cs-protected-bucket"
}
variable "function_execution_role_name" {
    description = "The name of the lambda execution IAM role"
    type = string
    default = "cs-protected-bucket-role"
}
variable "falconpy_layer_filename" {
    description = "The name of the archive to use for the lambda layer"
    type = string
    default = "falconpy-layer.zip"
}
variable "falconpy_layer_name" {
    description = "The name used for the lambda layer"
    type = string
    default = "crowdstrike_falconpy"
}
variable "function_filename" {
    description = "The name of the archive to use for the lambda function"
    type = string
    default = "quickscan-bucket.zip"
}
variable "function_name" {
    description = "The name used for the lambda function"
    type = string
    default = "cs_bucket_protection"
}
variable "function_mitigate_threats" {
    description = "Remove malicious files from the bucket as they are discovered."
    type = string
    default = "TRUE"
}
variable "sm_param_client_id" {
    description = "Name of the Secret Manager parameter storing the API client ID"
    type = string
    default = "CS_FALCONX_SCAN_CLIENT_ID"
}
variable "sm_param_client_secret" {
    description = "Name of the Secret Manager parameter storing the API client secret"
    type = string
    default = "CS_FALCONX_SCAN_CLIENT_SECRET"
}
variable "cidr_vpc" {
    description = "CIDR block for the VPC"
    default     = "10.99.0.0/16"
}
variable "cidr_subnet" {
    description = "CIDR block for the subnet"
    default     = "10.99.10.0/24"
}
variable "environment_tag" {
    description = "Environment tag"
    type        = string
    default     = "S3 Bucket Protection"
}
variable "trusted_ip" {
    description = "Trusted IP address to access the test bastion"
    type        = string
    default     = "1.1.1.1/32"
}
variable "ssh_group_name" {
    description = "Name of the security group allowing inbound SSH from the Trusted IP"
    type        = string
    default     = "CS-BUCKET-PROTECTION-TRUSTED-ADMIN"
}
variable "falcon_client_id" {
    description = "The CrowdStrike Falcon API client ID"
    type = string
    default = ""
    sensitive = true
}
variable "falcon_client_secret" {
    description = "The CrowdStrike Falcon API client secret"
    type = string
    default = ""
    sensitive = true
}
variable "function_description" {
    description = "The description used for the lambda function"
    type = string
    default = "CrowdStrike CS bucket protection"
}
variable "instance_name" {
    description = "The name of the Compute instance that is created to demo functionality"
    type = string
    default = "CS-BUCKET-PROTECTION-TEST"
}
variable "instance_key_name" {
    description = "The name of the SSH PEM key that will be used for authentication to the Compute instance"
    type = string
    default = ""
}
variable "iam_prefix" {
    description = "The prefix used for resources created within IAM"
	type = string
	default = "cs-bucket-protection"
}
variable "base_url" {
    description = "The Base URL for the CrowdStrike Cloud API"
    type = string
    default = "https://api.crowdstrike.com"
}
variable "instance_type" {
    description = "The type.size of the Compute instance that is created"
	type = string
	default = "e2-small"
}
