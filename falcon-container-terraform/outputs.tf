output "admin_access" {
  value       = "gcloud beta compute ssh --zone ${var.zone} ${google_compute_instance.vm_instance.name} --project ${var.project_id}"
  description = "Get access to the vm that manages the cluster"
}

output "admin_access_web" {
  value       = "https://console.cloud.google.com/compute/instancesDetail/zones/${var.zone}/instances/${google_compute_instance.vm_instance.name}?project=${var.project_id}"
}

output "vulnerable-example-com" {
  value       = "https://console.cloud.google.com/kubernetes/deployment/${var.zone}/${google_container_cluster.primary.name}/default/vulnerable.example.com/overview?project=${var.project_id}"
  description = "Link to vulnerable.example.com deployment. May take a few moments to come up"
}
