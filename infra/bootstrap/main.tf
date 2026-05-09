terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  default_labels = {
    environment = "shared-ops"
    managed_by  = "terraform"
  }
}

module "sre_ops_project" {
  source = "../modules/gcp-project"

  project_name       = var.project_id
  project_id         = var.project_id
  billing_account_id = var.billing_account_id
  # org_id             = var.org_id
  # folder_id          = var.folder_id
}

module "sre_ops_registry" {
  source = "../modules/registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "apps"

  depends_on = [module.sre_ops_project]
}

module "sre_projects" {
  source = "../modules/gcp-project"
  for_each = {
    for project_id, cfg in var.sre_projects :
    project_id => {
      # billing_account_id = cfg.billing_account_id
      billing_account_id = (
        try(cfg.billing_account_id, null) != null
        ? cfg.billing_account_id
        : var.billing_account_id
      )

      # If a per-project parent is specified, use it and ignore global defaults.
      # Otherwise, fall back to the top-level org_id/folder_id.
      org_id = (
        (try(cfg.org_id, null) != null || try(cfg.folder_id, null) != null)
        ? try(cfg.org_id, null)
        : var.org_id
      )
      folder_id = (
        (try(cfg.org_id, null) != null || try(cfg.folder_id, null) != null)
        ? try(cfg.folder_id, null)
        : var.folder_id
      )
    }
  }

  project_name       = each.key
  project_id         = each.key
  billing_account_id = each.value.billing_account_id
  org_id             = each.value.org_id
  folder_id          = each.value.folder_id
}

module "sre_github_sa" {
  source = "../modules/github-sa"

  for_each          = var.sre_projects
  target_project_id = each.key

  ops_project_id     = var.project_id
  ops_project_region = var.region
  ops_registry_repo  = module.sre_ops_registry.registry_repo_name

  tfstate_bucket_name = var.tf_state_bucket_name
  wif_pool_name       = module.sre_wip.wif_pool_name
  github_repo         = "${var.github_owner}/${var.github_repo}"

  depends_on = [module.sre_projects]
}

module "sre_gke_sa" {
  source = "../modules/gke-sa"

  for_each           = var.sre_projects
  ops_project_id     = var.project_id
  ops_project_region = var.region
  ops_registry_repo  = module.sre_ops_registry.registry_repo_name

  project_id   = each.key
  cluster_name = var.gke_cluster_name

  depends_on = [module.sre_projects]
}

module "sre_wip" {
  source = "../modules/github-wip"

  project_id = var.project_id
  # wif_pool_id     = var.wif_pool_id
  wif_provider_id = var.github_repo
  github_owner    = var.github_owner
  github_repo     = var.github_repo

  depends_on = [module.sre_ops_project]
}

module "sre_state_bucket" {
  source = "../modules/gcs-backend"

  project_id           = var.project_id
  region               = var.region
  tf_state_bucket_name = var.tf_state_bucket_name

  depends_on = [module.sre_ops_project]
}
