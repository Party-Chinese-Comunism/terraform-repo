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
  type        = string
  default     = "e2-medium"
}

variable "region" {
  description = "Região da GCP (ex: us-central1)"
  type        = string
  default     = "us-west1"
}

variable "public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "image" {
  description = "Imagem do sistema operacional para a VM"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts" 
}

variable "disk_size" {
  description = "Tamanho do disco da VM"
  type        = number
  default     = 10  
}

variable "credentials_file_path" {
  description = "Caminho para o arquivo de credenciais do GCP"
  type        = string
}
