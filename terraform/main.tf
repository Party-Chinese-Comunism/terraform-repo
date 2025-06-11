provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "google_container_cluster" "primary" {
  name     = "meu-cluster-gke-autopilot"
  location = var.region 
  autopilot = true  


  network    = "default"
  subnetwork = "default"

  enable_network_policy = true  
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}
