variable "project_id" {
    type = string
}

variable "project_name" {
    type = string
}

variable "environment" {
    type = string
    default = "prod"
}

variable "k8s_namespace" {
    type = string
    default = "production-apps"
}

variable "k8s_service_account_name" {
    type = string
    default = "app-runner-sa"
}