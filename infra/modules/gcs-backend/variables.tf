variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created."
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


