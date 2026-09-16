# ==========================================================================
# Core Project and Environment Context
# ==========================================================================

project_id   = "project-b072ca81-0008-42cb-81c" # Replace with your real GCP Project ID
project_name = "micro"
environment  = "prod"
region       = "us-central1"

# ==========================================================================
# GKE Integration Routing Mapping Keys
# ==========================================================================
# This key tells the root main.tf to pull the ID of the "gke-tier" subnet block
gke_subnet_key = "gke-tier"

# ==========================================================================
# Dynamic Subnets Topology Map
# ==========================================================================
subnets = {
  "gke-tier" = {
    region                   = "us-central1"
    ip_cidr                  = "10.0.10.0/24" # Fixed: Renamed from 'cidr' to 'ip_cidr'
    private_ip_google_access = true
    secondary_ranges = [
      {
        range_name    = "gke-pods"
        ip_cidr_range = "10.4.0.0/14"
      },
      {
        range_name    = "gke-services"
        ip_cidr_range = "10.8.0.0/20"
      }
    ]
  },
  "db-tier" = {
    region                   = "us-central1"
    ip_cidr                  = "10.0.20.0/24" # Fixed: Renamed from 'cidr' to 'ip_cidr'
    private_ip_google_access = true
    secondary_ranges         = []
  }
}
# ==========================================================================
# Dynamic Enterprise Least-Privilege Firewall Maps
# ==========================================================================
firewall_rules = {
  # 1. BASELINE CRITICAL SECURITY: Default drop all incoming traffic
  "deny-all-ingress" = {
    action        = "deny"
    priority      = 65000
    protocol      = "all"
    source_ranges = ["0.0.0.0/0"]
  },

  # 2. AUDIT & MANAGEMENT: Cloud IAP Secure Tunneling & Standard Health Checks
  "allow-gcp-mgmt" = {
    action   = "allow"
    priority = 1000
    protocol = "tcp"
    ports    = ["22", "80", "443"]
    source_ranges = [
      "35.191.0.0/16",   # Google Load Balancer Probes
      "130.211.0.0/22",  # Google Infrastructure Probes
      "35.235.240.0/20"  # Cloud Identity-Aware Proxy (Enables Secure SSH without Public IPs)
    ]
    target_tags = ["gke-node", "allow-mgmt"]
  },

  # 3. INTER-CLUSTER LATERAL CONTROL: Only allow GKE Nodes to call DB Tier
  "gke-to-database" = {
    action        = "allow"
    priority      = 1100
    protocol      = "tcp"
    ports         = ["5432", "3306"] # Postgres / MySQL
    source_ranges = ["10.0.10.0/24"]  # Restricts source exclusively to GKE Node CIDR block
    target_tags   = ["db-tier"]
  }
}

# ==========================================================================
# Workload Identity Engine Mapping Details
# ==========================================================================
k8s_namespace            = "production-apps"
k8s_service_account_name = "app-runner-sa"

# ==========================================================================
# GKE Node Pool Scaling Configurations
# ==========================================================================
gke_min_nodes = 1
gke_max_nodes = 3
