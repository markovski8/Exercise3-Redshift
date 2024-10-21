resource "aws_redshift_cluster" "RScluster" {
  cluster_identifier = var.rs-cluster-identifier1
  database_name = local.secret_data["name"]
  master_username = local.secret_data["username"]
  master_password = local.secret_data["password"]
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  manage_master_password = true
  number_of_nodes = var.no_nodes
  skip_final_snapshot = true
  depends_on = [ data.aws_secretsmanager_secret_version.RSsecretmanager ]
   iam_roles = [aws_iam_role.RSrole.arn]

  }
data "aws_secretsmanager_secret" "RSsecret" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "RSsecretmanager" {
  secret_id = data.aws_secretsmanager_secret.RSsecret.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.RSsecretmanager.secret_string)
}

# iams
resource "aws_iam_role" "RSrole" {
  name               = "RedshiftSecretAccessRole"
  description        = "IAM role for Redshift to access secrets in Secrets Manager"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "redshift_secret_access_policy" {
  name        = "RedshiftSecretAccessPolicy"
  description = "IAM policy for Redshift to access secrets in Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "redshift_policy_attachment" {
  name       = "RedshiftPolicyAttachment"
  policy_arn = aws_iam_policy.redshift_secret_access_policy.arn
  roles      = [aws_iam_role.RSrole.name]
}