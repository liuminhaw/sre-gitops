output "project_id" {
  description = "Created GCP project ID"
  value       = module.sre_ops_project.project_id
}

output "project_number" {
  description = "Created GCP project number"
  value       = module.sre_ops_project.project_number
}

output "billing_account_id" {
  description = "GCP billing account ID used for the project"
  value       = var.billing_account_id
}

output "tf_state_bucket_url" {
  description = "GCS bucket url for Terraform state"
  value       = module.sre_state_bucket.tf_state_bucket_url
}

output "additional_project_ids" {
  description = "Additional created GCP project ids keyed by project_id"
  value       = { for project_id, project in module.sre_projects : project_id => project.project_id }
}

output "wif_pool_name" {
  description = "Full resource name of the created Workload Identity Pool"
  value       = module.sre_wip.wif_pool_name
}

output "wif_provider_name" {
  description = "Full resource name of the created Workload Identity Pool Provider"
  value       = module.sre_wip.wif_provider_name
}

output "github_sa_email" {
  description = "Email of the created GitHub Actions service account"
  value       = { for project_id, sa in module.sre_github_sa : project_id => sa.github_sa_email }
}

output "registry_repo_id" {
  description = "The ID of the created Artifact Registry repository"
  value       = module.sre_ops_registry.registry_repo_id
}
