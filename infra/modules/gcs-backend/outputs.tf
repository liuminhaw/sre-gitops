output "tf_state_bucket_url" {
  value       = google_storage_bucket.terraform_state.url
  description = "The URL of the Terraform state storage bucket"
}

