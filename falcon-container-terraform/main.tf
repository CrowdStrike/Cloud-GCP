variable "project_id" {
  description = "GCP Project ID (project needs to exist already) (Alternatively, set env variable TF_VAR_project_id)"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "tenant" {
  description = "Please provide your nickname. The nickname will be used to name resources created by this demo. So the resource names don't clash with your co-workers."
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "containerregistry" {
  project = var.project_id
  service = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

