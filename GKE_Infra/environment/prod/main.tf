# i need to script for prod environment 

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project_id
  vpc     = "prod-core-vpc"
}

module "subnet" {
  source  = "../../modules/subnet"
  project = var.project_id
  subnet  = var.subnets
  
  # Bridges the gap between your two separate folders
  vpc_id  = module.vpc.vpc_id
}

module "gke" {
  source     = "../../modules/gke"
  project_id = var.project_id
  vpc_id     = module.vpc.vpc_id


  # Looks up the exact ID from your child subnet resource loop safely
  subnet_id  = module.subnets.subnet_ids[var.gke_subnet_key]
  
  # ... rest of your GKE arguments
}

module "security_firewall" {
  source         = "../../modules/firewall"
  project_id     = var.project_id
  environment    = var.environment
  vpc_name       = module.vpc.vpc_name
  firewall_rules = var.firewall_rules
}

# --------------------------------------------------------------------------
# 5. Artifact Registry Module Block
# --------------------------------------------------------------------------
module "artifact-registry" {
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
