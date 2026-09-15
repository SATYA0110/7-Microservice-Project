output "vpc_name" {
    value = google_compute_network.vpc.vpc.name
}

output "vpc_id" {
    value = google_compute_network.vpc.vpc.id
}