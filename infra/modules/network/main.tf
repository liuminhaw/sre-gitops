terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 13.1.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.routing_mode

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  depends_on = [google_project_service.compute]
}

# NAT Gateway and Cloud Router
resource "google_compute_address" "nat_ips" {
  count       = var.nat_ip_count
  name        = "${var.network_name}-nat-ip-${var.region}-${count.index + 1}"
  region      = var.region
  description = "NAT IP for ${var.network_name} in ${var.region}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_project_service.compute]
}

locals {
  nat_name = "${var.network_name}-nat-${var.region}"
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 8.3.0"

  count = var.nat_ip_count > 0 ? 1 : 0

  name       = "${var.network_name}-router-${var.region}"
  project_id = var.project_id
  network    = module.vpc.network_name
  region     = var.region

  nats = [{
    name                               = "${var.network_name}-nat-${var.region}"
    name                               = local.nat_name
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    # Use the created NAT IPs
    nat_ip_allocate_option = "MANUAL_ONLY"
    nat_ips                = google_compute_address.nat_ips.*.self_link

    # Dynamic minimum port allocation settings
    enable_dynamic_port_allocation = true
    min_ports_per_vm               = 64
    max_ports_per_vm               = 65536

    log_config = {
      enable = true
      filter = "ERRORS_ONLY"
    }
  }]

  depends_on = [google_project_service.compute]
}

