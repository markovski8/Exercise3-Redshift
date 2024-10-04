resource "aws_redshift_cluster" "RScluster" {
  cluster_identifier = "redshift-cluster"
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  manage_master_password = true

  }

resource "aws_secretsmanager_secret" "RSsecret" {
  name        = var.SMname
  description = "${var.project_name}-smng key"
/*   lifecycle {
    prevent_destroy = true
  } */
}

resource "aws_secretsmanager_secret_version" "RSsecretmanager" {
secret_id     = aws_secretsmanager_secret.RSsecret.id
secret_string = jsonencode({
database_name   = aws_redshift_cluster.RScluster.database_name
master_username    = var.master_username
master_password    = var.master_password
  })
}