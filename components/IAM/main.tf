

resource "aws_iam_role" "RSrole" {
  name = "${var.project_name}-RSrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
                    "scheduler.redshift.amazonaws.com",
                    "redshift.amazonaws.com"
                ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.project_name}-RSrole"
  }
}
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
resource "aws_iam_policy" "redshift_secret_access_policy" {
  name        = "RedshiftSecretAccessPolicy"
  description = "IAM policy for Redshift to access secrets in Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:RestoreSecret"
          
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "rs-secretm-policy-attachment" {
  role = aws_iam_role.RSrole.name
  policy_arn = aws_iam_policy.redshift-secret-manager-policy.arn
}
resource "aws_iam_role_policy_attachment" "rs-policy-attachment" {
    role = aws_iam_role.RSrole
    policy_arn = aws_iam_policy.redshift-scheduler-policy.arn
  
}
