resource "aws_iam_user" "datalake_admin" {
  name = var.users.datalake_admin.name
}

resource "aws_iam_user_login_profile" "datalake_admin" {
  user    = aws_iam_user.datalake_admin.name
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "datalake_admin_managed" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSLakeFormationDataAdmin",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSLakeFormationCrossAccountManager",
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
  ])
  user       = aws_iam_user.datalake_admin.name
  policy_arn = each.value
}

resource "aws_iam_user_policy" "datalake_admin_inline" {
  name = "LakeFormationSLR"
  user = aws_iam_user.datalake_admin.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:CreateServiceLinkedRole"
        Resource = "*"
        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = "lakeformation.amazonaws.com"
          }
        }
      },
      {
        Effect = "Allow"
        Action = "iam:PutRolePolicy"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "datalake_admin_lf_user_pass_role" {
  user       = aws_iam_user.datalake_admin.name
  policy_arn = aws_iam_policy.lf_user_pass_role_policy.arn
}

resource "aws_iam_user_policy_attachment" "datalake_admin_ram_access" {
  user       = aws_iam_user.datalake_admin.name
  policy_arn = aws_iam_policy.lf_ram_access_policy.arn
}