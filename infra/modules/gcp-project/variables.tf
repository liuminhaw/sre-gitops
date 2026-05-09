variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "project_name" {
  description = "The name of the GCP project"
  type        = string
}

variable "billing_account_id" {
  description = "The billing account ID associated with the project"
  type        = string
}

variable "org_id" {
  description = "The organization ID where the project will be created"
  type        = string
  default     = null
  nullable    = true
}

variable "folder_id" {
  description = "The folder ID where the project will be created"
  type        = string
  default     = null
  nullable    = true
}

