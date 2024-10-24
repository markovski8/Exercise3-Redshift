# resource "aws_redshift_cluster" "RScluster" {
#   cluster_identifier = var.rs_cluster_identifier1
#   database_name = local.secret_data["name"]
#   master_username = local.secret_data["username"]
#   master_password = local.secret_data["password"]
#   node_type          = var.node_type
#   cluster_type       = var.cluster_type
#   manage_master_password = true
#   number_of_nodes = var.no_nodes
#   skip_final_snapshot = true
#   depends_on = [ data.aws_secretsmanager_secret_version.RSsecretmanager ]
#   iam_roles = [aws_iam_role.RSrole.arn]
#   cluster_subnet_group_name = var.redsub-gr
  

#   }
data "aws_secretsmanager_secret" "RSsecret" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "RSsecretmanager" {
  secret_id = data.aws_secretsmanager_secret.RSsecret.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.RSsecretmanager.secret_string)
}

output "secret_data" {
  value = local.secret_data
}

# iams
resource "aws_iam_role" "RSrole" {
  name = "${var.project_name}-RSrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
                    "scheduler.redshift.amazonaws.com",
                    "redshift.amazonaws.com"
                ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_name}-RSrole"
  }
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