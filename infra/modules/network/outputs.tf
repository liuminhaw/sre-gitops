output "vpc_name" {
  description = "The name of the VPC network"
  value       = module.vpc.network_name
}

output "vpc_id" {
  description = "The ID of the VPC network"
  value       = module.vpc.network_id
}

output "vpc_self_link" {
  description = "The self link of the VPC network"
  value       = module.vpc.network_self_link
}

output "vpc_subnets_names" {
  description = "The list of subnet names in the VPC network"
  value       = module.vpc.subnets_names
}

output "vpc_subnets_ips" {
  description = "The list of subnet IP ranges in the VPC network"
  value       = module.vpc.subnets_ips
}

output "vpc_subnets" {
  description = "The list of subnet self_links in the VPC network"
  value       = module.vpc.subnets
}

output "nat_ips" {
  description = "The list of IP addresses allocated to the VPC network"
  value       = google_compute_address.nat_ips[*].address
}

output "cloud_router" {
  description = "The name of the Cloud Router"
  value       = length(module.cloud_router) > 0 ? module.cloud_router[0].router.name : ""
}

output "cloud_nat" {
  description = "The name of the Cloud NAT"
  value       = length(module.cloud_router) > 0 ? module.cloud_router[0].nat[local.nat_name].id : ""
}

output "cloud_nat_name" {
  description = "The name of the Cloud NAT"
  value       = length(module.cloud_router) > 0 ? module.cloud_router[0].nat[local.nat_name].name : ""
}

