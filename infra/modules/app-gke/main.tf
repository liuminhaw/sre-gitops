terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

locals {
  gcp_services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
    # "gatewaycertificates.googleapis.com"
  ]

  cluster_location = var.location_type == "regional" ? var.region : var.zone
  node_locations   = length(var.node_zones) > 0 ? var.node_zones : null
}

resource "google_project_service" "gke_apis" {
  for_each = toset(local.gcp_services)

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}

resource "google_compute_global_address" "static_ip" {
  name         = "gke-${var.cluster_name}-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"

  depends_on = [google_project_service.gke_apis]
}

resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = local.cluster_location

  network    = var.vpc_network
  subnetwork = var.vpc_subnet

  remove_default_node_pool = true
  initial_node_count       = 1

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Private cluster（重點）
  private_cluster_config {
    enable_private_nodes = true

    enable_private_endpoint = false

    # master control plane's CIDR (should not overlap with any existing network)
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  # secondary ranges（Pod / Service）
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  release_channel {
    channel = var.release_channel
  }

  deletion_protection = false

  lifecycle {
    precondition {
      condition     = var.location_type == "regional" || (var.zone != null && trimspace(var.zone) != "")
      error_message = "When location_type is zonal, zone must be set."
    }
  }

  depends_on = [google_project_service.gke_apis]
}

resource "google_container_node_pool" "nodes" {
  name     = "${var.cluster_name}-np"
  location = local.cluster_location
  cluster  = google_container_cluster.cluster.name

  node_locations = local.node_locations

  autoscaling {
    min_node_count = var.node_min
    max_node_count = var.node_max
  }

  # node_count for initialize
  node_count = var.node_min

  node_config {
    service_account = var.node_sa_email
    machine_type = var.node_machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = var.node_labels
  }

  management {
    auto_repair  = var.node_auto_repair
    auto_upgrade = var.node_auto_upgrade
  }

  depends_on = [google_project_service.gke_apis]
}
