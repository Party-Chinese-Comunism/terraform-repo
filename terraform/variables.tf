variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "cluster_name" {
  type  = string
  description = "nome do cluster"
}

variable "cluster_size" {
  type = string
  description = "tamanho do cluster"
}

variable "enable_ingress" {
  type    = bool
  default = false
}

variable "bucket_name" {
  type = string
  description = "nome do bucket"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-a"
}

variable "machine_type" {
  default = "e2-medium"
}

variable "image" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "credentials_file_path" {
  description = "Caminho para o arquivo de credenciais do Google Cloud"
  type        = string
}