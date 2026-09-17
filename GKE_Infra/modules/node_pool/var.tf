variable "project_id" {
    type = string
}

variable "region" {
    type = string
}

variable "gke_min_nodes" {
    type = number
}

variable "gke_max_nodes" {
    type = number
}

variable "environment" {
    type = string
}

variable "gke_cluster_name" {
  type = string
}

variable "node_service_account" {
type = string
}
