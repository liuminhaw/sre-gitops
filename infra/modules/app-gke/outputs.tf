output "cluster_static_ip_address" {
  description = "External IPv4 address for the cluster"
  value       = google_compute_global_address.static_ip.address
}

output "cluster_static_ip_name" {
  description = "Name of the reserved global address"
  value       = google_compute_global_address.static_ip.name
}

output "cluster_id" {
  description = "ID of the GKE cluster."
  value       = google_container_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the GKE cluster."
  value       = google_container_cluster.cluster.name
}

output "cluster_location" {
  description = "Location of the GKE cluster."
  value       = google_container_cluster.cluster.location
}

output "cluster_endpoint" {
  description = "Kubernetes API server endpoint."
  value       = google_container_cluster.cluster.endpoint
}

output "get_credential_command" {
  description = "Command to fetch kubeconfig credentials for this cluster."
  value = format(
    "gcloud container clusters get-credentials %s --%s %s --project %s",
    google_container_cluster.cluster.name,
    var.location_type == "regional" ? "region" : "zone",
    google_container_cluster.cluster.location,
    var.project_id
  )
}

# output "cluster_ca_certificate" {
#   description = "Base64 encoded public CA certificate for the cluster."
#   value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
#   sensitive   = true
# }

output "node_pool_id" {
  description = "ID of the default managed node pool."
  value       = google_container_node_pool.nodes.id
}

output "node_pool_name" {
  description = "Name of the default managed node pool."
  value       = google_container_node_pool.nodes.name
}
