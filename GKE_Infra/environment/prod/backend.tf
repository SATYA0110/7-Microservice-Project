

terraform {
  required_version = ">= 1.5.0"
    backend "gcs" {
        bucket = "prod-tfstate-bucket01"
        prefix = "terraform/state/production"

    }
}   