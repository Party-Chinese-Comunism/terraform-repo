provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

variable "static_ip" {
  description = "O endereço IP estático a ser usado no cluster"
  type        = string
}

resource "google_container_cluster" "primary" {
  name               = "cluster-prod-central"
  location           = var.region
  enable_autopilot   = true

  network    = "default"
  subnetwork = "default"


  endpoint = var.static_ip
}


output "ingress_ip_address" {
  value = var.static_ip
}


output "cluster_name" {
  value = google_container_cluster.primary.name
}
