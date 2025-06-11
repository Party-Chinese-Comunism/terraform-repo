provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name     = "meu-cluster-gke-hml"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1 

  network    = "default"
  subnetwork = "default"

}

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  node_config {
    machine_type = var.machine_type
    disk_size_gb = 10
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    tags = ["ssh", "app"]
  }

  initial_node_count = 1
}


# resource "google_compute_firewall" "allow_ssh_http" {
#   name    = "allow-ssh-http"
#   network = "default"
#
#   allow {
#     protocol = "tcp"
#     ports    = ["22", "80", "3000", "8000", "9090", "5000"]
#   }
#
#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["ssh", "app"]
# }
