provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

data "google_client_config" "default" {}

provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
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

resource "helm_release" "kube_prometheus_stack" {
  name             = "observability"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "57.0.2"

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

  # GKE Autopilot-safe configuration
  set {
    name  = "defaultRules.create"
    value = "false"
  }

  set {
    name  = "kubelet.enabled"
    value = "false"
  }

  set {
    name  = "coreDns.enabled"
    value = "false"
  }

  set {
    name  = "nodeExporter.enabled"
    value = "false"
  }

  set {
    name  = "kubeControllerManager.enabled"
    value = "false"
  }

  set {
    name  = "kubeScheduler.enabled"
    value = "false"
  }

  set {
    name  = "kubeProxy.enabled"
    value = "false"
  }

  set {
    name  = "kubeEtcd.enabled"
    value = "false"
  }

  depends_on = [google_container_cluster.primary]
}
