resource "aws_iam_user" "datalake_user1" {
  name = var.users.datalake_user1.name
}

resource "aws_iam_user_login_profile" "datalake_user1" {
  user                    = aws_iam_user.datalake_user1.name
  password_reset_required = true
}

resource "aws_iam_user_policy" "datalake_user1_basic" {
  name = "DatalakeUserBasic"
  user = aws_iam_user.datalake_user1.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lakeformation:GetDataAccess",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersions",
          "glue:SearchTables",
          "glue:UpdateTable",
          "glue:GetPartitions",
          "lakeformation:GetResourceLFTags",
          "lakeformation:ListLFTags",
          "lakeformation:GetLFTag",
          "lakeformation:SearchTablesByLFTag",
          "lakeformation:SearchDatabasesByLFTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "datalake_user1_athena_access" {
  user       = aws_iam_user.datalake_user1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_user_policy_attachment" "datalake_user1_governed_table" {
  user       = aws_iam_user.datalake_user1.name
  policy_arn = aws_iam_policy.lf_governed_table_policy.arn
}