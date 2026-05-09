terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

module "gke_service_account" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 4.7.0"
  project_id   = var.project_id
  names        = ["gke-${var.cluster_name}-sa"]
  display_name = "GKE ${var.cluster_name} Service Account"
  description  = "Managed by Terraform - GKE cluster service account"

  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
    "${var.project_id}=>roles/monitoring.viewer",
    "${var.project_id}=>roles/stackdriver.resourceMetadata.writer",
    "${var.project_id}=>roles/artifactregistry.reader",
    "${var.project_id}=>roles/compute.networkViewer"
  ]
}

resource "google_artifact_registry_repository_iam_member" "allow_gke_pull" {
  project    = var.ops_project_id
  location   = var.ops_project_region
  repository = var.ops_registry_repo

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${module.gke_service_account.email}"
}
