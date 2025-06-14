data "google_client_config" "default" {}

provider "helm" {
  alias = "gke"
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

resource "helm_release" "nginx_ingress" {
  count    = var.enable_ingress ? 1 : 0
  provider = helm.gke

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

  # Garante que só seja aplicado após o cluster GKE e IP estarem prontos
  depends_on = [
    google_container_cluster.primary,
    google_compute_address.ingress_ip
  ]
}
