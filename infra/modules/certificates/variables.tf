variable "project_id" {
  description = "Target GCP Project ID"
  type        = string
}

variable "maps_config" {
  description = "Define the list of Certificate Maps to be created"

  # Key: Map identifier (e.g., "prod-lb-map", "dev-lb-map")
  # Value: Map description
  type = map(object({
    description = optional(string)
  }))

  validation {
    # Logical Analysis:
    # 1. for k, v in var.maps_config: Iterates through each key (k) within the map.
    # 2. regex("^[a-z0-9-]+$", k): Validates whether the key consists strictly of lowercase letters, numbers, and hyphens from start to finish.
    # 3. can(...): Returns true if the regex match is successful; otherwise, returns false.
    # 4. alltrue(...): Ensures that all keys in the map return true for the condition to pass globally.
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

