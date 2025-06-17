variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "credentials_file_path" {
  type = string
}

variable "enable_ingress" {
  type    = bool
  default = false
}