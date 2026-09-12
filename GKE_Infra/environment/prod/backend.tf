terraform {
    backend "gcs" {
        bucket = "prod-tfstate-bucket"
        prefix = "terraform/state/production"

    }
}   