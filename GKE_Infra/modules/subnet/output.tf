
output "subnet_names" {
  value = { for k, v in google_compute_subnetwork.subnet : k => v.name }
  description = "A map of all provisioned subnet keys to their actual GCP resource names."
}

output "subnet_ids" {
  value = { for k, v in google_compute_subnetwork.subnet : k => v.id }
  description = "A map of all provisioned subnet keys to their unique GCP self-link/IDs."
}
