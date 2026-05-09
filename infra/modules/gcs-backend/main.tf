terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_storage_bucket" "terraform_state" {
  name          = var.tf_state_bucket_name
  location      = var.region
  force_destroy = false

  # Enable Object Versioning to protect against accidental deletions
  versioning {
    enabled = true
  }

  # Prevent accidental deletion of the bucket by Terraform command
  lifecycle {
    prevent_destroy = true
  }

  # Prevent bucket public access
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

