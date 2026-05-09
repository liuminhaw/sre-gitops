variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region to create artifact registry repository"
  type        = string
}

variable "repository_id" {
  description = "Artifact registry repository ID"
  type        = string

  default = "apps"
}

variable "cleanup_policy_keep_count" {
  description = "Number of most recent versions to keep in the artifact registry repository cleanup policy"
  type        = number
  default     = 10
}

