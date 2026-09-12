resource "google_container_cluster" "gke" {
    name = var.name
    location = var.region
    network = var.vpc_id
    project = var.project.id
    subnetwork = var.subnet.id
    remove_default_node_pool = true
    initial_node_count = 1

    ip_allocation_policy {
        cluster_secondary_range_name = "gke-pods"
        services_secondary_range_name = "gke-services"
    }

    private_cluster_config {
    enable_private_nodes    = true  # Worker nodes have ZERO public IPs
    enable_private_endpoint = false # Keep control plane endpoint public but securely whitelisted
    master_ipv4_cidr_block  = "172.16.0.0/28" # Dedicated non-overlapping /28 management block
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8" # Replace/expand with Bastion Host, Cloud IAP, or office IP blocks
      display_name = "internal-vpc-management-access"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Production Auditing & Infrastructure Observability Logs
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