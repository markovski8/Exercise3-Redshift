

resource "aws_iam_role" "RSrole" {
  name = "${var.project_name}-RSrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "scheduler.redshift.amazonaws.com",
          "redshift.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "${var.project_name}-RSrole"
  }
}
# Policy to allow Redshift to pause and resume clusters
resource "aws_iam_policy" "redshift-scheduler-policy" {
  name        = "${var.project_name}-redshift-scheduler-policy"
  description = "Policy to allow Redshift to start and stop clusters"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "redshift:PauseCluster",
          "redshift:ResumeCluster"
        ],
        Resource = "*"
      }
    ]
  })
}

# Policy to allow Redshift to read from Secrets Manager
resource "aws_iam_policy" "redshift_secret_access_policy" {
  name        = "${var.project_name}-redshift-secret-access-policy"
  description = "Policy to allow Redshift to access Secrets Manager for admin credentials"

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



# Attach the Secrets Manager access policy to the Redshift role
resource "aws_iam_role_policy_attachment" "rs-secretm-policy-attachment" {
  role       = aws_iam_role.RSrole.name
  policy_arn = aws_iam_policy.redshift_secret_access_policy.arn
}

# Attach the scheduler policy to the Redshift role
resource "aws_iam_role_policy_attachment" "rs-policy-attachment" {
  role       = aws_iam_role.RSrole.name
  policy_arn = aws_iam_policy.redshift-scheduler-policy.arn
}

