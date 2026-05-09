terraform {
  required_version = "~> 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  default_labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

module "sre_gitops_vpc" {
  source = "../../modules/network"

  project_id       = var.project_id
  region           = var.region
  network_name     = var.network_name
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
  nat_ip_count     = var.nat_ip_count
}

module "sre_gitops_cert" {
  source = "../../modules/certificates"

  project_id     = var.project_id
  maps_config    = var.maps_config
  domains_config = var.domains_config
}

module "sre_gitops_gke" {
  source = "../../modules/app-gke"

  project_id                    = var.project_id
  region                        = var.region
  location_type                 = var.gke_location_type
  zone                          = var.gke_zone
  cluster_name                  = var.gke_cluster_name
  vpc_network                   = module.sre_gitops_vpc.vpc_id
  vpc_subnet                    = module.sre_gitops_vpc.vpc_subnets["${var.region}/${var.gke_subnet}"].id
  master_ipv4_cidr_block        = var.gke_master_ipv4_cidr_block
  pods_secondary_range_name     = var.gke_pods_secondary_range_name
  services_secondary_range_name = var.gke_services_secondary_range_name
  node_sa_email                 = var.gke_service_account_email
  node_zones                    = var.gke_node_zones
  node_machine_type             = var.gke_node_machine_type
}
