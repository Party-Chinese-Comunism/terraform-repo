output "cluster_name" {
  description = "Nome do cluster GKE criado"
  value       = google_container_cluster.primary.name
}


