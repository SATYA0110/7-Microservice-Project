resource "google_compute_network" "vpc" {
    name = var.vpc
    auto_create_subnetworks = false
    routing_mode = "REGIONAL"
    project = var.project
}