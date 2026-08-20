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
  description = "Policy for the Data Lake service role - S3, Glue, Lake Formation and CloudWatch Logs access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # S3 access to data lake zones
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
      },
      {
        # Glue Data Catalog and ETL jobs
        Effect = "Allow"
        Action = [
          "glue:CreateJob",
          "glue:UpdateJob",
          "glue:DeleteJob",
          "glue:GetJob",
          "glue:GetJobs",
          "glue:StartJobRun",
          "glue:StopJobRun",
          "glue:BatchStopJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:CreateDatabase",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:UpdateDatabase",
          "glue:DeleteDatabase",
          "glue:CreateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:UpdateTable",
          "glue:DeleteTable",
          "glue:CreatePartition",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:UpdatePartition",
          "glue:DeletePartition",
          "glue:BatchCreatePartition",
          "glue:BatchDeletePartition",
          "glue:GetUserDefinedFunction",
          "glue:GetUserDefinedFunctions",
          "glue:CreateUserDefinedFunction",
          "glue:UpdateUserDefinedFunction",
          "glue:DeleteUserDefinedFunction",
          "glue:GetConnection",
          "glue:GetConnections",
          "glue:CreateConnection",
          "glue:UpdateConnection",
          "glue:DeleteConnection",
          "glue:GetDataCatalogEncryptionSettings",
          "glue:GetWorkflow",
          "glue:GetWorkflowRun",
          "glue:GetWorkflowRuns",
          "glue:GetTags",
          "glue:TagResource",
          "glue:UntagResource"
        ]
        Resource = "*"
      },
      {
        # Lake Formation - obtain scoped S3 credentials for registered locations
        Effect = "Allow"
        Action = [
          "lakeformation:GetDataAccess"
        ]
        Resource = "*"
      },
      {
        # CloudWatch Logs for Glue job logging
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/*"
      },
      {
        # Pass the role to Glue jobs
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = aws_iam_role.datalake_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datalake_role_policy_attachment" {
  role       = aws_iam_role.datalake_role.name
  policy_arn = aws_iam_policy.datalake_policy.arn
}
