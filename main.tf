module "vpc" {
    source = "./components/vpc"
    project_name = var.project_name
    vpcRS_cidr = var.vpcRS_cidr
    subRSa_cidr = var.subRSa_cidr
    subRSb_cidr = var.subRSb_cidr
    AZa = var.AZa
    AZb = var.AZb
    cidrvpc = var.vpcRS_cidr
    app_environment = var.app_environment
    app_name = var.app_name
  
}

module "redshift" {
source = "./components/redshift"
  project_name = var.project_name
  database_name      = var.rs_database_name
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  SMname = var.SMname
  no_nodes = var.no_nodes
  rs-cluster-ident = var.rs-cluster-ident
  secret_arn = module.secretM.secret_arn
  redsub-gr = module.vpc.redshift-sub-gr
  rs_database_name = var.rs_database_name
  rs_username = var.rs_username 
  rs_password = var.rs_password
  iam_roles_arn = module.IAM.iam_roles_arn
  r-public = var.r-public
  RSencrypted = var.RSencrypted
  sgRS = module.vpc.sgRS-id
  secret_id         = module.secretmanager.secret_id
  secret_version_id = module.secretmanager.secret_version_id
  
  


  

}

module "secretM" {
  source = "./components/secretM"
  SMname = var.SMname
  rs_database_name = var.rs_database_name 
  project_name = var.project_name
  rs_username = var.rs_username
  rs_password = var.rs_password
  cluster_type = var.cluster_type
  node_type = var.node_type
  
  
}
module "IAM" {
  source = "./components/IAM"
  project_name = var.project_name
  
}
 
output "secret_arn" {
  value = module.secretM.secret_arn
}

output "rs-cluster-ident" {
  value = var.rs-cluster-ident
}

# output "master_password" {
#   value = local.secret_data["password"]
# }



# variable "rs_password" {
#   description = "Redshift master password"
#   type        = string
#   sensitive   = true  # Mark as sensitive to avoid displaying in logs
# }

# variable "rs_username" {
#   description = "Redshift master username"
#   type        = string
# }

# variable "rs_database_name" {
#   description = "Name of the database"
#   type        = string
# }

# output "debug_master_password" {
#   value = local.secret_data["password"]
#   sensitive = true  # This will prevent it from being displayed in logs
# }