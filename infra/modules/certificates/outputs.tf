output "certificate_map_ids" {
  description = "List of created Certificate Map IDs (Keyed by Map name)"
  value = {
    for key, map_res in google_certificate_manager_certificate_map.default :
    key => map_res.id
  }
}

output "external_dns_auth_records" {
  description = "DNS records for domain validation (for domains without Cloud DNS zones)"
  value = {
    for domain, config in var.domains_config : domain => {
      record_name  = google_certificate_manager_dns_authorization.default[domain].dns_resource_record[0].name
      record_type  = google_certificate_manager_dns_authorization.default[domain].dns_resource_record[0].type
      record_value = google_certificate_manager_dns_authorization.default[domain].dns_resource_record[0].data
    }
    if config.dns_zone_name == null
  }
}

