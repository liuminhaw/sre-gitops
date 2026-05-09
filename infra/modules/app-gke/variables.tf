variable "project_id" {
  description = "GCP project ID used by Workload Identity pool."
  type        = string
}

variable "node_sa_email" {
  description = "The email of the GKE cluster's node service account."
  type        = string
}

variable "node_labels" {
  description = "Labels to apply to node pool instances."
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "location_type" {
  description = "Cluster location type: regional or zonal."
  type        = string
  default     = "regional"

  validation {
    condition     = contains(["regional", "zonal"], var.location_type)
    error_message = "location_type must be either 'regional' or 'zonal'."
  }
}

variable "region" {
  description = "Region where the GKE regional cluster is created."
  type        = string
}

variable "zone" {
  description = "Zone where the GKE zonal cluster is created. Required when location_type is zonal."
  type        = string
  default     = null
}

variable "vpc_network" {
  description = "VPC network self link or name for the cluster."
  type        = string
}

variable "vpc_subnet" {
  description = "VPC subnetwork self link or name for the cluster."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "RFC1918 CIDR block for the GKE control plane."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Secondary range name used for Pods."
  type        = string
}

variable "services_secondary_range_name" {
  description = "Secondary range name used for Services."
  type        = string
}

variable "release_channel" {
  description = "GKE release channel."
  type        = string
  default     = "REGULAR"

  validation {
    condition = contains(
      ["RAPID", "REGULAR", "STABLE", "EXTENDED", "UNSPECIFIED"],
      var.release_channel
    )
    error_message = "release_channel must be one of RAPID, REGULAR, STABLE, EXTENDED, UNSPECIFIED."
  }
}

variable "node_zones" {
  description = "Optional list of zones for node pool placement. Leave empty to let GKE decide."
  type        = list(string)
  default     = []
}

variable "node_min" {
  description = "Minimum number of nodes for autoscaling."
  type        = number
  default     = 1
}

variable "node_max" {
  description = "Maximum number of nodes for autoscaling."
  type        = number
  default     = 1
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes."
  type        = string
}

variable "node_auto_repair" {
  description = "Enable automatic node repair."
  type        = bool
  default     = true
}

variable "node_auto_upgrade" {
  description = "Enable automatic node upgrades."
  type        = bool
  default     = true
}
