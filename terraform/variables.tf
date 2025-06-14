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
variable "static_ip" {
  description = "O endereço IP estático a ser usado no cluster"
  type        = string
}
