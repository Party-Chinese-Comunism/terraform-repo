provider "google" {
  credentials = file("./credentials.json")
  project     = "seu-projeto-gcp-aqui"
  region      = "us-central1"
}

resource "google_container_cluster" "primary" {
  name             = "cluster-prod-central"
  location         = "us-central1"
  enable_autopilot = true
  network          = "default"
  subnetwork       = "default"
}

data "google_client_config" "default" {}

provider "helm" {
  kubernetes {
    host                   = "https://{google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

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
    value = "LoadBalancer"
  }

  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "prometheus-node-exporter.enabled"
    value = "false"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "false"
  }

  depends_on = [google_container_cluster.primary]
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}
