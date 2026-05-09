output "github_sa_email" {
  description = "Email of the created GitHub Actions service account"
  value       = google_service_account.github.email
}
