variable "project_id" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "cluster-hml-central"
}

variable "cluster_size" {
  type    = number
  default = 1
}

variable "enable_ingress" {
  type    = bool
  default = true
}

variable "bucket_name" {
  type    = string
  default = "blog-iris-hml"
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "zone" {
  type    = string
  default = "us-east1-b"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "image" {
  type    = string
  default = "cos_containerd"
}

variable "credentials_file_path" {
  type = string
}
