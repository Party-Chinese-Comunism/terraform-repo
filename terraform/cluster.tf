provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name             = "cluster-hml-central"
  location         = var.region
  enable_autopilot = true

  network    = "default"
  subnetwork = "default"
}

resource "google_compute_address" "ingress_ip" {
  name   = "ingress-static-ip"
  region = var.region
}
