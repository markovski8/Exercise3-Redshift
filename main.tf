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

}

