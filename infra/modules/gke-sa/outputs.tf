output "gke_sa_email" {
  description = "The email of the GKE cluster service account"
  value       = module.gke_service_account.email
}
