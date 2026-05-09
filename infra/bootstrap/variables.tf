variable "project_id" {
  description = "GCP project ID to create and store shared ops resources."
  type        = string
}

# variable "project_name" {
#   description = "GCP Project name to create and store shared ops resources."
#   type        = string
# }

variable "billing_account_id" {
  description = "GCP billing account ID to use for the project."
  type        = string
}

variable "sre_projects" {
  description = "Map of <project_id> => { billing_account_id, (optional) org_id, (optional) folder_id } to create additional GCP projects. If org_id/folder_id are omitted for a project, the top-level org_id/folder_id variables are used as defaults."
  type = map(object({
    billing_account_id = optional(string)
    org_id             = optional(string)
    folder_id          = optional(string)
  }))
  default = {}
}

variable "org_id" {
  description = "The organization ID where the projects will be created"
  type        = string
  default     = null
  nullable    = true
}

variable "folder_id" {
  description = "The folder ID where the projects will be created"
  type        = string
  default     = null
  nullable    = true
}

variable "region" {
  description = "GCP region to deploy state bucket."
  type        = string
}

variable "tf_state_bucket_name" {
  description = "The name of the GCS bucket to store Terraform state."
  type        = string

  validation {
    condition = (
      length(var.tf_state_bucket_name) >= 3 &&
      length(var.tf_state_bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9._-]*[a-z0-9]$", var.tf_state_bucket_name)) &&
      !startswith(var.tf_state_bucket_name, "goog") &&
      !can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.tf_state_bucket_name))
    )

    error_message = <<EOT
    Invalid bucket name "${var.tf_state_bucket_name}". Bucket names must meet the following criteria:
    1. length between 3-63 characters.
    2. only lowercase letters, numbers, dashes (-), underscores (_), or dots (.).
    3. must start and end with a letter or number.
    4. cannot start with "goog".
    5. cannot be in IP address format.
    EOT
  }
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repository"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without owner)"
  type        = string
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}
