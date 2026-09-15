# i need to script for prod environment 

module "vpc" {
  source  = "../../modules/vpc"
  project_id = var.project_id
  vpc     = "prod-core-vpc"
}

module "subnet" {
  source  = "../../modules/subnet"
  project_id = var.project_id
  subnets  = var.subnets
  
  # Bridges the gap between your two separate folders
  vpc_name = module.vpc.vpc_name
}

module "gke" {
  source     = "../../modules/gke"
  project_id = var.project_id
  vpc_id     = module.vpc.vpc_id
  region       = var.region
  project_name = var.project_id
  environment  = "dev"



  # Looks up the exact ID from your child subnet resource loop safely
  subnet_id  = module.subnet.subnet_ids[var.gke_subnet_key]
  
  # ... rest of your GKE arguments
}

module "firewall" {
  source         = "../../modules/firewall"
  project_id     = var.project_id
  project_name  = var.project_name
  environment    = var.environment
  vpc_name       = module.vpc.vpc_name
  firewall_rules = var.firewall_rules
}

# --------------------------------------------------------------------------
# 5. Artifact Registry Module Block
# --------------------------------------------------------------------------
module "artifact-registry" {
  source        = "../../modules/artifact-registry"
  project_id   = var.project_id
  project_name = var.project_name
  environment  = var.environment
  region       = var.region
}


# --------------------------------------------------------------------------
# 6. Secure Workload Identity Module Block
# --------------------------------------------------------------------------
module "workload_identity" {
  source                   = "../../modules/workload_identity"
  project_id               = var.project_id
  project_name             = var.project_name
  environment              = var.environment
  k8s_namespace            = var.k8s_namespace
  k8s_service_account_name = var.k8s_service_account_name
}
