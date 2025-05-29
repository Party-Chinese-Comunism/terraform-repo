variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "disk_size" {
  default = 20
}

variable "image" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "public_key_path" {
  default = "C:/Users/FireW/.ssh/id_rsa.pub"
}