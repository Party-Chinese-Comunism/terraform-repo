variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "credentials_file_path" {
  type = string
}

variable "zone" {
  type        = string
  description = "The GCP zone to create the cluster in"
}
