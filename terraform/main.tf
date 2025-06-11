provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "google_container_cluster" "primary" {
  name     = "meu-cluster-gke-autopilot"
  location = var.region  


  initial_node_count = 1 
  remove_default_node_pool = true  

  # Rede e sub-rede onde o cluster será criado (se necessário, altere conforme sua configuração de rede)
  network    = "default"
  subnetwork = "default"

}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}
