provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

# Cluster GKE com Autopilot ativado
resource "google_container_cluster" "primary" {
  name             = "cluster-hml-central"
  location         = var.region
  enable_autopilot = true

  network    = "default"
  subnetwork = "default"
}

# Coleta token de autenticação para o provider helm
data "google_client_config" "default" {}

# IP fixo para uso com o Ingress NGINX
resource "google_compute_address" "ingress_ip" {
  name   = "ingress-static-ip"
  region = var.region
}

# Provedor Helm (só funciona após o cluster existir)
provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

# Instalação do Ingress NGINX, protegida com count para evitar execução antes do cluster
resource "helm_release" "nginx_ingress" {
  count            = var.enable_ingress ? 1 : 0
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.ingress_ip.address
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}