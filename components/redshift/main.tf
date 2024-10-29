data "aws_secretsmanager_secret" "rs-secret" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "rs-secretmanager" {
  secret_id = data.aws_secretsmanager_secret.rs-secret.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.rs-secretmanager.secret_string)
}

resource "aws_redshift_cluster" "rs-cluster" {
  cluster_identifier = var.rs-cluster-ident
  database_name = local.secret_data["name"]
  master_username = local.secret_data["username"]
  master_password = local.secret_data["password"]
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  skip_final_snapshot = true
  number_of_nodes = var.no_nodes
  depends_on = [ data.aws_secretsmanager_secret_version.rs-secretmanager ]
  iam_roles = [var.iam_roles_arn]
  cluster_subnet_group_name = var.redsub-gr
  publicly_accessible = var.r-public
  encrypted = var.RSencrypted
  vpc_security_group_ids = var.sgRSid
 
  
  

  }
  

# output "secret_data" {
#   value = local.secret_data
# }


# output "master_password" {
#   value = local.secret_data["password"]
# }



# variable "rs_password" {
#   description = "Redshift master password"
#   type        = string
#   sensitive   = true  # Mark as sensitive to avoid displaying in logs
# }

# variable "rs_username" {
#   description = "Redshift master username"
#   type        = string
# }

# variable "rs_database_name" {
#   description = "Name of the database"
#   type        = string
# }

# output "debug_master_password" {
#   value = local.secret_data["password"]
#   sensitive = true  # This will prevent it from being displayed in logs
# }

resource "aws_redshift_scheduled_action" "resume" {
  name     = "resume-redshift-cluster"
  schedule = "cron(0 8 ? * MON-FRI *)"
  iam_role = var.iam_roles_arn

  target_action {
    resume_cluster {
      cluster_identifier = aws_redshift_cluster.rs-cluster.cluster_identifier
    }
  }
}

resource "aws_redshift_scheduled_action" "pause" {
  name     = "pause-redshift-cluster"
  schedule = "cron(0 17 ? * MON-FRI *)"
  iam_role = var.iam_roles_arn

  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.rs-cluster.cluster_identifier
    }
  }
}