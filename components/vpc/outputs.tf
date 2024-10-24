output "redshift-sub-gr" {
  value = aws_redshift_subnet_group.redshift-sub-gr.name
}

# output "iam_roles_arn" {
#   description = "iam role arn"
#   value       = aws_iam_role.RSrole.arn
# }
# output "secgrpid" {
#   description = "security group id redshift"
#   value       = [aws_default_security_group.redshift-sub-gr.id]
# }