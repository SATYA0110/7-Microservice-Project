# ==========================================================================
# Core Project and Environment Context
# ==========================================================================

variable "project.id" {
  type        = string
  description = "The target Google Cloud Platform (GCP) Project ID."
}

variable "project_name" {
  type        = string
  description = "A short prefix or project code used for resource naming consistency across components."
}

variable "environment" {
  type        = string
  description = "The target deployment lifecycle environment stage (e.g., prod)."
  default     = "prod"
}

variable "region" {
  type        = string
  description = "The default GCP region where regional components will be provisioned."
  default     = "us-central1"
}

# ==========================================================================
# GKE Integration Routing Mapping Keys
# ==========================================================================

variable "gke_subnet_key" {
  type        = string
  description = "The exact map key name of the subnet allocated for GKE nodes (matches the key used in var.subnets)."
  default     = "gke-tier"
}

# ==========================================================================
# Dynamic Network Topology Structures
# ==========================================================================

variable "subnets" {
  type = map(object({
    region                   = string
    ip_cidr                  = string
    private_ip_google_access = optional(bool, true)
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  description = "A comprehensive multi-tier network structure detailing regions, primary CIDRs, and GKE sub-allocations."
}

# ==========================================================================
# Dynamic Enterprise Least-Privilege Firewall Maps
# ==========================================================================

variable "firewall_rules" {
  type = map(object({
    action                  = optional(string, "allow")
    direction               = optional(string, "INGRESS")
    priority                = optional(number, 1000)
    protocol                = string
    ports                   = optional(list(string))
    source_ranges           = optional(list(string))
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    project.id = string
  }))
  description = "A collection mapping containing standard ingress/egress policies across your production VPC."
}

# ==========================================================================
# Workload Identity Engine Mapping Details
# ==========================================================================

variable "k8s_namespace" {
  type        = string
  description = "The target core Kubernetes namespace housing your production running software instances."
  default     = "production-apps"
}

variable "k8s_service_account_name" {
  type        = string
  description = "The matching Kubernetes native ServiceAccount identity inside the cluster to associate with the cloud role."
  default     = "app-runner-sa"
}