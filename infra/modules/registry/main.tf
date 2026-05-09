terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_project_service" "artifact_registry_api" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "apps" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for apps"
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-latest-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = var.cleanup_policy_keep_count
    }
  }
  cleanup_policy_dry_run = false

  depends_on = [google_project_service.artifact_registry_api]
}



