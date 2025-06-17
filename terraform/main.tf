provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

data "google_compute_address" "ingress_ip" {
  name   = "ingress-static-ip"
  region = var.region
}

resource "google_container_cluster" "primary" {
  name             = "cluster-hml-central"
  location         = var.region
  enable_autopilot = true

  network    = "default"
  subnetwork = "default"
}

# Observabilidade: Prometheus + Grafana com Ingress NGINX
resource "helm_release" "kube_prometheus_stack" {
  name             = "observability"
  namespace        = "monitoring"
  create_namespace = true

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "57.0.2"

  set {
    name  = "grafana.adminPassword"
    value = "admin123"
  }

  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }

  set {
    name  = "grafana.ingress.path"
    value = "/grafana"
  }

  set {
    name  = "grafana.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
    value = "/$1"
  }

  set {
    name  = "grafana.ingress.pathType"
    value = "ImplementationSpecific"
  }

  set {
    name  = "prometheus.ingress.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.ingress.path"
    value = "/prometheus"
  }

  set {
    name  = "prometheus.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "prometheus.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
    value = "/$1"
  }

  set {
    name  = "prometheus.ingress.pathType"
    value = "ImplementationSpecific"
  }

  depends_on = [google_container_cluster.primary]
}