output "cluster_name" {
  description = "Nome do cluster GKE criado"
  value       = google_container_cluster.primary.name
}

output "ingress_static_ip" {
  value = google_compute_address.ingress_ip.address
}