output "project_id" {
  description = "Primary GCP project id"
  value       = google_project.project.project_id
}

output "project_number" {
  description = "Primary GCP project number"
  value       = google_project.project.number
}

output "project_name" {
  description = "Primary GCP project name"
  value       = google_project.project.name
}

