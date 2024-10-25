output "redshift-sub-gr" {
  description = "redshift subnet group"
  value = aws_redshift_subnet_group.redshift-sub-gr.name
}

output "sgRS-id" {
  description = "security group id redshift"
  value       = [aws_security_group.sgRS.id]
}