terraform {
    required_version = ">= 1.5.0"
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~> 6.0"
        }
    }
}

provider "google" {
    project = var.project_id
    region = var.region
    impersonate_service_account = "id-19589081310-compute-develop@project-b072ca81-0008-42cb-81c.iam.gserviceaccount.com"
}
