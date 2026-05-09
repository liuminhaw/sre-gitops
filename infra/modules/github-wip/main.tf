terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_project_service" "iamcredentials" {
  project            = var.project_id
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = var.wif_pool_id
  display_name              = "GitHub Actions Pool"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = var.wif_provider_id
  display_name                       = "GitHub OIDC Provider"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  # 常用 mapping（GitHub OIDC claims）
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.event_name"       = "assertion.event_name"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
    "attribute.workflow"         = "assertion.workflow"
  }

  # 建議鎖 repo（至少鎖 owner；更嚴謹可以鎖到 main branch/ref）
  # attribute_condition = "assertion.repository_owner == '${var.github_owner}' && assertion.repository == '${var.github_owner}/${var.github_repo}'"
  attribute_condition = <<EOT
  assertion.repository == "${var.github_owner}/${var.github_repo}" &&
  (
    assertion.ref == "refs/heads/main" ||
    assertion.ref.startsWith("refs/pull/") ||
    assertion.event_name == "workflow_dispatch"
  )
  EOT
}
