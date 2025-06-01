provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file(var.credentials_file_path)
}


resource "google_compute_instance" "vm_instance" {
  name         = "dev-vm"
  machine_type = var.machine_type  
  zone         = var.zone         

  boot_disk {
    initialize_params {
      image = var.image         
      size  = var.disk_size       
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"  
  }

  tags = ["ssh", "app"]
}

#resource "google_compute_firewall" "allow_ssh_http" {
 # name    = "allow-ssh-http"
#  network = "default"

#  allow {
#    protocol = "tcp"
#    ports    = ["22", "80", "3000", "8000"]
#  }

#  source_ranges = ["0.0.0.0/0"]
#  target_tags   = ["ssh", "app"]

#  lifecycle {
#    ignore_changes = [
#      source_ranges,
#      target_tags,
#      allow,
#    ]
#  }
#}

