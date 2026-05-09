variable "ops_project_id" {
  description = "GCP project ID for shared ops resources."
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

variable "project_id" {
  description = "GCP project ID used by Workload Identity pool."
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

