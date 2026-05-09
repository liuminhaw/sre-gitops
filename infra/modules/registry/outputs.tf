output "registry_repo_id" {
  value       = google_artifact_registry_repository.apps.id
  description = "The ID of the repository in Artifact Registry"
}

output "registry_repo_name" {
  value       = google_artifact_registry_repository.apps.name
  description = "The name of the repository in Artifact Registry"
}

output "registry_repo_uri" {
  value       = google_artifact_registry_repository.apps.registry_uri
  description = "The URL of the repository in Artifact Registry"
}


