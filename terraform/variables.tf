variable "project_id" {
  description = "O ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "A região do GCP"
  default     = "us-central1"
}

variable "zone" {
  description = "A zona do GCP"
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Tipo da máquina para a instância"
  default     = "e2-medium"
}

variable "image" {
  description = "Imagem do sistema operacional"
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size" {
  description = "Tamanho do disco da instância"
  default     = 20
}

variable "public_key_path" {
  description = "Caminho para a chave pública SSH"
  default     = "~/.ssh/id_rsa.pub"  
}

variable "credentials_file_path" {
  description = "Caminho para o arquivo de credenciais do Google Cloud"
  type        = string
}
