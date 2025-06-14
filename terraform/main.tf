provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name               = "cluster-prod-central"
  location           = var.region
  enable_autopilot   = true

  network    = "default"
  subnetwork = "default"

  node_pool {
    name               = "default-node-pool"
    location           = var.region
    initial_node_count = 1
    node_config {
      machine_type = "e2-medium"
    }

   
    tags = ["http-server", "https-server"]
  }

 
}


output "cluster_name" {
  value = google_container_cluster.primary.name
}


output "ingress_ip_address" {
  value = var.static_ip
}
