output "redshift_endpoint" {
  value = aws_redshift_cluster.rs-cluster.endpoint
  description = "The endpoint for the Redshift cluster"
}