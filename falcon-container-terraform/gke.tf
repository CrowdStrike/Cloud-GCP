# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.tenant}-demo"
  location = var.zone

  initial_node_count = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}
