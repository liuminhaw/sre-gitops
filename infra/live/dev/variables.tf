variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

# variable "billing_account_id" {
#   description = "GCP billing account ID to use for the project."
#   type        = string
# }

variable "region" {
  description = "The region where the VPC network resources will be created"
  type        = string
}

variable "nat_ip_count" {
  description = "The number of NAT IP addresses to create for Cloud NAT"
  type        = number
  default     = 1
}

variable "routing_mode" {
  description = "The routing mode of the VPC network"
  type        = string
  default     = "GLOBAL"

  validation {
    condition     = contains(["GLOBAL", "REGIONAL"], var.routing_mode)
    error_message = "routing_mode must be either 'GLOBAL' or 'REGIONAL'."
  }
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "The list of subnets to be created, including regular and proxy-only subnets"
  type = list(object({
    subnet_name           = string
    subnet_ip             = string
    subnet_region         = string
    subnet_private_access = optional(bool, true)
    subnet_flow_logs      = optional(bool, false)
    description           = optional(string)

    # For Proxy-only Subnet
    # purpose = "REGIONAL_MANAGED_PROXY"
    # role    = "ACTIVE"
    purpose = optional(string)
    role    = optional(string)
  }))
  default = []
}

variable "secondary_ranges" {
  description = "Secondary ranges map where key is the subnet name and value is a list of secondary range objects."

  # 定義結構
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))

  default = {}
}

variable "maps_config" {
  description = "Define the list of Certificate Maps to be created"

  # Key: Map identifier (e.g., "prod-lb-map", "dev-lb-map")
  # Value: Map description
  type = map(object({
    description = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.maps_config : can(regex("^[a-z][a-z0-9-]+$", k))
    ])
    error_message = "All keys in maps_config must only contain lowercase letters (a-z), numbers (0-9), and hyphens (-). For example: 'lb-map-01'"
  }

  default = {
    "lb-map" = { description = "Default Load Balancer Map" }
  }
}

variable "domains_config" {
  description = "Define domain settings and specify the associated Map Key"

  type = map(object({
    target_map_key  = string           # Corresponds to maps_config keys (determines which Map this domain is attached to).
    enable_wildcard = bool             # Whether to use *.domain.com
    dns_zone_name   = optional(string) # Cloud DNS Zone name (set to null for external DNS).
  }))

  # Example reference:
  # default = {
  #   "example.com" = {
  #     target_map_key  = "prod-lb-map"
  #     enable_wildcard = true
  #     dns_zone_name   = "example-zone"
  #   }
  #   "dev.example.com" = {
  #     target_map_key  = "dev-lb-map" 
  #     enable_wildcard = true
  #     dns_zone_name   = null
  #   }
  # }
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "gke_location_type" {
  description = "GKE location mode. Use regional or zonal."
  type        = string
  default     = "regional"

  validation {
    condition     = contains(["regional", "zonal"], var.gke_location_type)
    error_message = "gke_location_type must be one of: regional, zonal."
  }
}

variable "gke_zone" {
  description = "GKE zone when gke_location_type is zonal."
  type        = string
  default     = null
}

variable "gke_subnet" {
  description = "The subnet name used by GKE in the selected region."
  type        = string
}

variable "gke_master_ipv4_cidr_block" {
  description = "The RFC1918 CIDR block for the GKE control plane."
  type        = string
}

variable "gke_pods_secondary_range_name" {
  description = "Secondary range name for GKE Pods."
  type        = string
}

variable "gke_services_secondary_range_name" {
  description = "Secondary range name for GKE Services."
  type        = string
}

variable "gke_node_zones" {
  description = "List of zones used by the GKE node pool."
  type        = list(string)
  default     = []
}

variable "gke_node_machine_type" {
  description = "Machine type for GKE node pool instances."
  type        = string
}

variable "gke_service_account_email" {
  description = "Service account to be used by GKE nodes."
  type        = string
}

