terraform {
  backend "gcs" {
    bucket = "sre-haw-terraform-state"
    prefix = "prod/sre-gitops"
  }
}

