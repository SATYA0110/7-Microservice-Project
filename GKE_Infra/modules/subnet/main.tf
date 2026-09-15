resource "google_compute_subnetwork" "subnet" {
    for_each = var.subnets
    name = each.key
    ip_cidr_range = each.value.ip_cidr
    region = each.value.region
    network = var.vpc_name
    project = var.project_id

    private_ip_google_access = lookup(each.value, "private_ip_google_access", true)

    purpose = "PRIVATE"
    role = "ACTIVE"

    # Include the secondary dynamic range loop to support your GKE logic natively
  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ranges", [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}