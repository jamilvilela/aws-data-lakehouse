resource "aws_iam_role" "lakeformation_workflow_role" {
  name        = "LFWorkflowRole"
  description = "Permissions to use LF Workflow feature"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lakeformation.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lf_workflow_permissions" {
  name = "LFWorkflowPermissions"
  role = aws_iam_role.lakeformation_workflow_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lakeformation:GetDataAccess",
          "lakeformation:GrantPermissions"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lakeformation_workflow_role_attachment" {
  role       = aws_iam_role.lakeformation_workflow_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}