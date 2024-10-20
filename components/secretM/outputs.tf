output "secret_arn" {
  value = aws_secretsmanager_secret.RSsecret.arn
}
output "secret_name" {
  value = aws_secretsmanager_secret.RSsecretmanager.name
}
output "secret_id" {
  value = aws_secretsmanager_secret.RSsecret.id
}
output "secret_version_id" {
  value = aws_secretsmanager_secret_version.RSsecretmanager.id
}