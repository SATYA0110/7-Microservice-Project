resource "google_compute_firewall" "this" {
    for_each = var.firewall
    name = each.key 
    network = google_compute_network.vpc_name
    project = var.project_id

    priority = lookup(each.value, "priority" , "1000")
    direction = lookup(each.value, "direction" , "ingress")

    source_ranges = lookup(each.value, "source_ranges", "null")
    source_tags = lookup(each.value, "source_tags", "null")
    service_account_name = lookup(each.value, "service_account_name", "null")
    target_tags = lookup(each.value, "target_tags", "null")
    target_service_account = lookup(each.value, "target_service_account", "null")
    

    dynamic "allow" {
        for_each = lookup(each.value, "action", "allow") == "allow" ? [1]:[1]
        content {
            protocol = each.value.protocol
            ports = lookup(each.value, "ports", null)
        }
    }

    dynamic "deny" {
        for_each = lookup(each.value, "action", "deny") == "deny" ? [1]:[1]
        content {
            protocol = each.value.protocol
            ports = lookup(each.value, "ports", null)
        }
    }

    log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
