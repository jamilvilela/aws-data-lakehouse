resource "aws_iam_role" "datalake_role" {
  name = var.datalake_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "glue.amazonaws.com",
            "states.amazonaws.com",
            "athena.amazonaws.com",
            "s3.amazonaws.com",
            "sns.amazonaws.com",
            "sqs.amazonaws.com",
            "firehose.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "datalake_policy" {
  name        = var.datalake_policy_name
  description = "Policy for Data Lake service role — apenas S3 essencial (outros serviços têm roles próprias)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::lakehouse-landing-*",
          "arn:aws:s3:::lakehouse-raw-*",
          "arn:aws:s3:::lakehouse-trusted-*",
          "arn:aws:s3:::lakehouse-business-*",
          "arn:aws:s3:::lakehouse-workspace-*"
        ]
      }
    ]
  })
}
