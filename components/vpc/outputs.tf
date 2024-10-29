output "redshift-sub-gr" {
  description = "redshift subnet group"
  value = aws_redshift_subnet_group.redshift-sub-gr.name
}

output "sgRSid" {
  description = "security group id redshift"
  value       = [aws_default_security_group.redshift_security_group.id]
}