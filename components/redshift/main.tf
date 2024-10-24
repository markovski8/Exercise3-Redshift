resource "aws_redshift_cluster" "rs-cluster" {
  cluster_identifier = var.rs-cluster-ident
  database_name = local.secret_data["name"]
  master_username = local.secret_data["username"]
  master_password = local.secret_data["password"]
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  # manage_master_password = true
  number_of_nodes = var.no_nodes
  skip_final_snapshot = true
  depends_on = [ data.aws_secretsmanager_secret_version.rs-secretmanager ]
  iam_roles = [aws_iam_role.RSrole.arn]
  cluster_subnet_group_name = var.redsub-gr
  

  }
data "aws_secretsmanager_secret" "rs-secret" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "rs-secretmanager" {
  secret_id = data.aws_secretsmanager_secret.rs-secret.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.rs-secretmanager.secret_string)
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
          "secretsmanager:DescribeSecret",
          "secretsmanager:RestoreSecret"
          
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
output "master_password" {
  value = local.secret_data["password"]
}



variable "rs_password" {
  description = "Redshift master password"
  type        = string
  sensitive   = true  # Mark as sensitive to avoid displaying in logs
}

variable "rs_username" {
  description = "Redshift master username"
  type        = string
}

variable "rs_database_name" {
  description = "Name of the database"
  type        = string
}

output "debug_master_password" {
  value = local.secret_data["password"]
  sensitive = true  # This will prevent it from being displayed in logs
}