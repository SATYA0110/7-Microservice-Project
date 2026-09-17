resource "google_container_node_pool" "gke_node" {
    name = "prod-node-pool"
    cluster = var.gke_cluster_name
    project = var.project_id
    location =  var.region

    initial_node_count = var.gke_min_nodes
    autoscaling {
        min_node_count = var.gke_min_nodes
        max_node_count = var.gke_max_nodes
    }

    management {
        auto_repair = true
        auto_upgrade = true
    }

    node_config {
        machine_type = "e2-standard-4"
        image_type = "COS_CONTAINERD"

        disk_size_gb = 50
        disk_type    = "pd-ssd"
    service_account = var.node_service_account

    # ✅ FIXED: Changed to the required full URL string literal
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      environment = var.environment
      tier        = "application-core"
    }

    }

}
