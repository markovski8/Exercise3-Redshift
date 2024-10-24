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
  database_name      = var.rs_database_name
  # master_username    = var.RS_username
  # master_password    = var.RS_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  project_name = var.project_name
  SMname = var.SMname
  no_nodes = var.no_nodes
  rs-cluster-ident = var.rs-cluster-ident
  secret_arn = module.secretM.secret_arn
  redsub-gr = module.vpc.redshift-sub-gr
  rs_database_name = var.rs_database_name
  RS_username = var.RS_username 
  RS_password = var.RS_password

}

module "secretM" {
  source = "./components/secretM"
  master_username = var.RS_username
  master_password = var.RS_password
  SMname = var.SMname
  rs_database_name = var.rs_database_name 
  project_name = var.project_name
  RS_username = var.RS_username
  RS_password = var.RS_password
  cluster_type = var.cluster_type
  node_type = var.node_type
  
  
}
output "secret_arn" {
  value = module.secretM.secret_arn
}

output "rs-cluster-ident" {
  value = var.rs-cluster-ident
}

