provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

# Criação do IP Estático
resource "google_compute_address" "ingress_ip" {
  name   = "ingress-static-ip"
  region = var.region
}

# Criação do Cluster GKE
resource "google_container_cluster" "primary" {
  name               = "cluster-prod-central"
  location           = var.region
  enable_autopilot   = true

  network    = "default"
  subnetwork = "default"

  node_pool {
    name       = "default-node-pool"
    location   = var.region
    initial_node_count = 3
    node_config {
      machine_type = "e2-medium"
    }

    # Usando tags para habilitar tráfego HTTP e HTTPS
    tags = ["http-server", "https-server"]
  }


  endpoint = google_compute_address.ingress_ip.address
}

output "ingress_ip_address" {
  value = google_compute_address.ingress_ip.address
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}
