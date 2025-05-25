resource "aws_iam_policy" "lf_workflow_pass_role_policy" {
  name        = "LFWorkflowSelfPassRole"
  description = "Policy to allow LFWorkflowRole to pass itself"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = aws_iam_role.lakeformation_workflow_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lf_workflow_pass_role_policy_attachment" {
  role       = aws_iam_role.lakeformation_workflow_role.name
  policy_arn = aws_iam_policy.lf_workflow_pass_role_policy.arn
}

resource "aws_iam_policy" "lf_user_pass_role_policy" {
  name        = "LFUserPassRole"
  description = "Policy to allow datalake-admin to pass roles"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess",
          aws_iam_role.lakeformation_workflow_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "lf_ram_access_policy" {
  name        = "LFRamAccess"
  description = "Policy to allow datalake-admin to manage RAM"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ram:AcceptResourceShareInvitation",
          "ram:RejectResourceShareInvitation",
          "ec2:DescribeAvailabilityZones",
          "ram:EnableSharingWithAwsOrganization"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lf_governed_table_policy" {
  name        = "LFGovernedTablePolicy"
  description = "Policy to allow datalake-user-01 to use governed tables"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "glue:GetTable",
          "glue:GetPartitions",
          "glue:UpdateTable",
          "lakeformation:StartTransaction",
          "lakeformation:CommitTransaction",
          "lakeformation:CancelTransaction",
          "lakeformation:ExtendTransaction",
          "lakeformation:DescribeTransaction",
          "lakeformation:ListTransactions",
          "lakeformation:GetTableObjects",
          "lakeformation:UpdateTableObjects",
          "lakeformation:DeleteObjectsOnCancel",
          "lakeformation:StartQueryPlanning",
          "lakeformation:GetQueryState",
          "lakeformation:GetQueryStatistics",
          "lakeformation:GetWorkUnits",
          "lakeformation:GetWorkUnitResults",
          "lakeformation:ListTableStorageOptimizers",
          "lakeformation:UpdateTableStorageOptimizer"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws-lakeformation-acceleration/compaction/logs:*"
      }
    ]
  })
}