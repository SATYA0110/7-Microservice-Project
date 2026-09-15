resource "google_project_service" "container" {
  project            = var.project_id
  service            = "://googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "gke" {
  name       = var.name
  location   = var.region
  network    = var.vpc_id
  project    = var.project_id
  subnetwork = var.subnet_id # Fixed: Swapped var.subnet.id for the clean string variable

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  private_cluster_config {
    enable_private_nodes    = true 
    enable_private_endpoint = false 
    master_ipv4_cidr_block  = "172.16.0.0/28" 
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8" 
      display_name = "internal-vpc-management-access"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  logging_config {
    enabled_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  
  monitoring_config {
    enabled_components = ["SYSTEM_COMPONENTS"]
  }

  release_channel {
    channel = "REGULAR"
  }

  depends_on = [google_project_service.container]
}
