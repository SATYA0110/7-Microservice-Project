

terraform {
  required_version = ">= 1.5.0"
    backend "gcs" {
        bucket = "prod-tfstate-bucket02"
        prefix = "terraform/state/production"

    }
}   
