output "wif_pool_name" {
  # projects/<NUM>/locations/global/workloadIdentityPools/<POOL>
  description = "Full resource name of the created Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github.name
}

output "wif_provider_name" {
  # projects/<NUM>/locations/global/workloadIdentityPools/<POOL>/providers/<PROVIDER>
  description = "Full resource name of the created Workload Identity Pool Provider"
  value       = google_iam_workload_identity_pool_provider.github.name
}
