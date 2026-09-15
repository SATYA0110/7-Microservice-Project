resource "google_compute_network" "vpc" {
    name = var.vpc
    auto_create_subnetworks = false
    routing_mode = "REGIONAL"
    project_id = var.project_id
}