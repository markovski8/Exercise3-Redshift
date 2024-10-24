output "secret_arn" {
  value = aws_secretsmanager_secret.rs-secret.arn
}
output "secret_name" {
  value = aws_secretsmanager_secret.rs-secret.name
}
output "secret_id" {
  value = aws_secretsmanager_secret.rs-secret.id
}
output "secret_version_id" {
  value = aws_secretsmanager_secret_version.rs-secretmanager.id

  
}

