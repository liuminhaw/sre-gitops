variable "ops_project_id" {
  description = "GCP Project ID that hosts shared ops resources (e.g., the tfstate bucket)"
  type        = string
}

variable "ops_project_region" {
  description = "GCP region to deploy shared ops resources."
  type        = string
}

variable "ops_registry_repo" {
  description = "Artifact Registry repository name for shared ops resources."
  type        = string
}

variable "target_project_id" {
  description = "GCP Project ID where GitHub Actions will deploy resources"
  type        = string
}

variable "tfstate_bucket_name" {
  description = "Name of the GCS bucket that stores Terraform state"
  type        = string
}

variable "wif_pool_name" {
  description = "Full Workload Identity Pool resource name used in principalSet bindings (e.g., projects/<number>/locations/global/workloadIdentityPools/<pool_id>)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in <owner>/<repo> format (matches OIDC assertion.repository)"
  type        = string
}

variable "sa_account_id" {
  description = "The account ID of the service account to create for GitHub Actions. This is the unique identifier that will be used in the service account email address."
  type        = string
  default     = "github-actions-sa"
}
