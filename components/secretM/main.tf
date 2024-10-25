
resource "aws_secretsmanager_secret" "rs-secret" {
  name        = var.SMname
  description = "${var.project_name}-smng key"
/*   lifecycle {
    prevent_destroy = true
  } */
}

resource "aws_secretsmanager_secret_version" "rs-secretmanager" {
secret_id     = aws_secretsmanager_secret.rs-secret.id
secret_string = jsonencode({
name   = var.rs_database_name
username    = var.rs_username
password    = var.rs_password
  })
}

resource "aws_iam_policy" "redshift-secret-manager-policy" {
  name        = "${var.project_name}-redshift-secrets-manager-policy"
  description = "Policy to allow Redshift to read from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rs-secretm-policy-attachment" {
  role = module.redshift.iam_roles.name
  policy_arn = module.redshift.aws_iam_role.RSrole.arn
}