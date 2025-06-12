provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name     = "cluster-hml"
  location = var.zone

  enable_autopilot = true  # Habilita o modo Autopilot

  network    = "default"
  subnetwork = "default"
}
