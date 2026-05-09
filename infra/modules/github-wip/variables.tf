variable "project_id" {
  description = "GCP Project ID where the Workload Identity Pool/Provider will be created"
  type        = string
}

variable "wif_pool_id" {
  description = "Workload Identity Pool ID (workload_identity_pool_id)"
  type        = string
  default     = "github"
}

variable "wif_provider_id" {
  description = "Workload Identity Pool Provider ID (workload_identity_pool_provider_id)"
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repository"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without owner)"
  type        = string
}
