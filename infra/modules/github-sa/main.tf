terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

locals {
  repo = var.github_repo

  # principalSet：把「某 repo」鎖死
  # principalSet://iam.googleapis.com/<POOL_NAME>/attribute.repository/<OWNER>/<REPO>
  wif_repo_principal = "principalSet://iam.googleapis.com/${var.wif_pool_name}/attribute.repository/${local.repo}"
}

resource "google_service_account" "github" {
  account_id   = var.sa_account_id
  display_name = "GitHub Actions Service Account"
  project      = var.target_project_id
}

resource "google_storage_bucket_iam_member" "tfstate_access" {
  bucket = var.tfstate_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github.email}"
}

resource "google_artifact_registry_repository_iam_member" "allow_gke_rw" {
  project    = var.ops_project_id
  location   = var.ops_project_region
  repository = var.ops_registry_repo

  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.github.email}"
}

resource "google_service_account_iam_member" "wif_binding" {
  service_account_id = google_service_account.github.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.wif_repo_principal
}

resource "google_project_iam_member" "container_admin" {
  project = var.target_project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "compute_admin" {
  project = var.target_project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "registry_admin" {
  project = var.target_project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "certificate_editor" {
  project = var.target_project_id
  role    = "roles/certificatemanager.editor"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "lb_admin" {
  project = var.target_project_id
  role    = "roles/compute.loadBalancerAdmin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "service_account_admin" {
  project = var.target_project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "service_usage_admin" {
  project = var.target_project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.target_project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "project_iam_admin" {
  project = var.target_project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.github.email}"
}
