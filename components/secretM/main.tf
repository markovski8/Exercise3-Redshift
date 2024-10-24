
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

