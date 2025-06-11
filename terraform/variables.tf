variable "project_id" {
  description = "O ID do projeto GCP"
  type        = string
}

variable "zone" {
  description = "Zona da GCP (ex: us-central1-a)"
  type        = string
  default     = "us-central1-a"
}


variable "machine_type" {
  description = "Tipo da máquina para os nós do cluster"
  default     = "e2-small"
}
variable "region" {
  description = "Região da GCP (ex: us-central1)"
  type        = string
  default     = "us-west1"
}


variable "public_key_path" {
  description = "Caminho para a chave pública SSH"
  default     = "~/.ssh/id_rsa.pub"
}
