variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

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
  default     = "REGIONAL"

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

  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))

  default = {}
}

