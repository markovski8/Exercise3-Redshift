module "vpc" {
    source = "./components/vpc"
    vpcRS_cidr = var.vpcRS_cidr
    subRSa_cidr = var.subRSa_cidr
    subRSb_cidr = var.subRSb_cidr
    AZa = var.AZa
    AZb = var.AZb
    cidrvpc = var.vpcRS_cidr
}

module "redshift" {
source = "./components/redshift"
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type
#   db_name = var.db_name
#   db_username = var.db_username
#   db_password = var.db_password
  project_name = var.project_name
  SMname = var.SMname
  no_nodes = var.no_nodes
  rs-cluster-identifier1 = var.rs-cluster-identifier1
  secret_arn = module.secretM.secret_arn

}

module "secretM" {
  source = "./components/secretM"
  master_username = var.master_username
  master_password = var.master_password
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
