provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "primary" {
  name             = "cluster-prod-central"
  location         = var.region  
  enable_autopilot = true  

  network    = "default"
  subnetwork = "default"
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

#output "ingress_ip_address" {
#  value = var.static_ip
#}

# Configuração do provedor do Google
data "google_client_config" "default" {}

# Configuração do provedor Helm para Kubernetes
provider "helm" {
  kubernetes {
    host                   = google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

# Release do Grafana e Prometheus
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
