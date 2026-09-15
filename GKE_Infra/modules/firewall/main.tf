resource "google_compute_firewall" "this" {
  for_each = var.firewall_rules # Fixed: Mapped to correct variable name
  
  name    = each.key 
  network = var.vpc_name        # Fixed: Using variable input instead of missing resource
  project = var.project_id

  priority  = each.value.priority
  direction = each.value.direction

  source_ranges           = each.value.source_ranges
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts # Fixed: Corrected GCP argument name
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts # Fixed: Corrected GCP argument name

  # Dynamic ALLOW block
  dynamic "allow" {
    for_each = lower(each.value.action) == "allow" ? [1] : [] # Fixed: Produces empty list if not allow
    content {
      protocol = each.value.protocol # Fixed: using each.value (from the resource loop)
      ports    = each.value.ports
    }
  }

  # Dynamic DENY block
  dynamic "deny" { # Fixed: Fixed 'deynamic' typo
    for_each = lower(each.value.action) == "deny" ? [1] : [] # Fixed: Produces empty list if not deny
    content {
      protocol = each.value.protocol 
      ports    = each.value.ports
    }
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
