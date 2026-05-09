output "project_id" {
  description = "The ID of the created GCP project"
  value       = var.project_id
}

output "region" {
  description = "The region where the VPC network resources are created"
  value       = var.region
}

output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = var.gke_cluster_name
}

# output "billing_account_id" {
#   description = "GCP billing account ID used for the project"
#   value       = var.billing_account_id
# }

output "vpc_name" {
  description = "The name of the VPC network"
  value       = module.sre_gitops_vpc.vpc_name
}

output "vpc_id" {
  description = "The ID of the VPC network"
  value       = module.sre_gitops_vpc.vpc_id
}

output "vpc_self_link" {
  description = "The self link of the VPC network"
  value       = module.sre_gitops_vpc.vpc_self_link
}

output "vpc_subnets" {
  description = "The list of subnet self_links in the VPC network"
  value       = module.sre_gitops_vpc.vpc_subnets
}

output "nat_ips" {
  description = "The list of IP addresses allocated to the VPC network"
  value       = module.sre_gitops_vpc.nat_ips
}

output "certificate_map_ids" {
  description = "The list of created certificate map ids"
  value       = module.sre_gitops_cert.certificate_map_ids
}

output "dns_auth_records" {
  description = "The list of DNS authorization records with created ssl certificates"
  value       = module.sre_gitops_cert.external_dns_auth_records
}

output "gke_cluster_ip_address" {
  description = "External IPv4 address allocated for the GKE cluster"
  value       = module.sre_gitops_gke.cluster_static_ip_address
}

output "gke_cluster_ip_name" {
  description = "The name of the external IPv4 address allocated for the GKE cluster"
  value       = module.sre_gitops_gke.cluster_static_ip_name
}

output "gke_get_credential_command" {
  description = "The command to get credentials for the created GKE cluster"
  value       = module.sre_gitops_gke.get_credential_command
}

output "gke_cluster_id" {
  description = "The ID of the created GKE cluster"
  value       = module.sre_gitops_gke.cluster_id
}

output "gke_cluster_endpoint" {
  description = "The endpoint of the created GKE cluster"
  value       = module.sre_gitops_gke.cluster_endpoint
}

output "gke_cluster_location" {
  description = "The location of the created GKE cluster"
  value       = module.sre_gitops_gke.cluster_location
}

output "cert_maps_config_key" {
  description = "The only key in maps_config (errors if there is not exactly one key)"
  value       = one(keys(var.maps_config))
}

output "domains_config_key" {
  description = "The only key in domains_config (errors if there is not exactly one key)"
  value       = one(keys(var.domains_config))
}
