terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

# Enable the Certificate Manager API
resource "google_project_service" "certificate_manager_api" {
  service            = "certificatemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_certificate_manager_dns_authorization" "default" {
  for_each    = var.domains_config
  name        = "auth-${replace(each.key, ".", "-")}"
  description = "DNS Auth for ${each.key}"
  domain      = each.key
  depends_on  = [google_project_service.certificate_manager_api]
}

resource "google_dns_record_set" "cname_validation" {
  for_each     = { for k, v in var.domains_config : k => v if v.dns_zone_name != null }
  managed_zone = each.value.dns_zone_name
  name         = google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.default[each.key].dns_resource_record[0].data]

  depends_on = [google_project_service.certificate_manager_api]
}

resource "google_certificate_manager_certificate" "default" {
  for_each    = var.domains_config
  name        = "cert-${replace(each.key, ".", "-")}"
  description = "Cert for ${each.key}"
  # project     = var.project_id
  scope = "DEFAULT"
  managed {
    domains            = each.value.enable_wildcard ? [each.key, "*.${each.key}"] : [each.key]
    dns_authorizations = [google_certificate_manager_dns_authorization.default[each.key].id]
  }

  depends_on = [google_project_service.certificate_manager_api]
}

# Generate Certificate Maps based on maps_config variable
resource "google_certificate_manager_certificate_map" "default" {
  for_each = var.maps_config

  name        = each.key # Use the map key as the resource name (e.g., "lb-map")
  description = each.value.description

  depends_on = [google_project_service.certificate_manager_api]
}

# This local block processes the domains_config to create entries for both root and wildcard domains
locals {
  map_entries_list = flatten([
    for domain, config in var.domains_config : [
      {
        key        = "${domain}-root"
        cert_key   = domain
        hostname   = domain
        entry_name = "entry-${replace(domain, ".", "-")}-root"
        # Key point: pass down the map key specified for this domain
        target_map = config.target_map_key
      },
      config.enable_wildcard ? {
        key        = "${domain}-wildcard"
        cert_key   = domain
        hostname   = "*.${domain}"
        entry_name = "entry-${replace(domain, ".", "-")}-wildcard"
        target_map = config.target_map_key
      } : null
    ]
  ])

  map_entries = {
    for entry in local.map_entries_list : entry.key => entry if entry != null
  }
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  for_each = local.map_entries

  name = each.value.entry_name

  # Dynamically point to the correct Map resource
  # This searches through the 'maps' collection created above
  map = google_certificate_manager_certificate_map.default[each.value.target_map].name

  certificates = [google_certificate_manager_certificate.default[each.value.cert_key].id]
  hostname     = each.value.hostname

  depends_on = [google_project_service.certificate_manager_api]
}

