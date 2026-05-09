terraform {
  backend "gcs" {
    bucket = "sre-haw-terraform-state"
    prefix = "staging/sre-gitops"
  }
}

