################################################################################
# IAM Groups para Data Lake com modelo de acesso baseado em roles
# 
# Os usuários são adicionados aos grupos. Os grupos têm políticas que permitem
# sts:AssumeRole para roles LF específicas. Assim, todas as permissões de
# acesso ao Lake Formation vêm das roles, centralizando a governança.
################################################################################

# ==============================================================================
# Grupo 1: datalake-admins
# Permissões: criar/deletar/alterar catalogs, databases, tables, dados em S3, 
#             visualizar em Athena, gerenciar Lake Formation
# ==============================================================================

resource "aws_iam_group" "datalake_admins" {
  name = "datalake-admins"
}

resource "aws_iam_group_policy" "datalake_admins_assume_role" {
  name   = "AllowAssumeAdminRole"
  group  = aws_iam_group.datalake_admins.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.datalake_admins_lf_role.arn
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "datalake_admins_lf_data_admin" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLakeFormationDataAdmin"
}

resource "aws_iam_group_policy_attachment" "datalake_admins_glue_console" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_group_policy_attachment" "datalake_admins_cloudwatch" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "datalake_admins_lf_cross_account" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLakeFormationCrossAccountManager"
}

resource "aws_iam_group_policy_attachment" "datalake_admins_athena" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_group_policy_attachment" "datalake_admins_cfn_readonly" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
}

resource "aws_iam_group_policy" "datalake_admins_slr" {
  name   = "LakeFormationSLR"
  group  = aws_iam_group.datalake_admins.name
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

resource "aws_iam_group_policy_attachment" "datalake_admins_pass_role" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = aws_iam_policy.lf_user_pass_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "datalake_admins_ram_access" {
  group      = aws_iam_group.datalake_admins.name
  policy_arn = aws_iam_policy.lf_ram_access_policy.arn
}

# ==============================================================================
# Grupo 2: datalake-users-internal
# Permissões: consulta/leitura de databases e tabelas, queries em Athena
# ==============================================================================

resource "aws_iam_group" "datalake_users_internal" {
  name = "datalake-users-internal"
}

resource "aws_iam_group_policy" "datalake_users_internal_assume_role" {
  name   = "AllowAssumeInternalUserRole"
  group  = aws_iam_group.datalake_users_internal.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.datalake_users_internal_lf_role.arn
      }
    ]
  })
}

resource "aws_iam_group_policy" "datalake_users_internal_basic" {
  name   = "DatalakeInternalUserBasic"
  group  = aws_iam_group.datalake_users_internal.name
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

resource "aws_iam_group_policy_attachment" "datalake_users_internal_athena" {
  group      = aws_iam_group.datalake_users_internal.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_group_policy_attachment" "datalake_users_internal_governed_table" {
  group      = aws_iam_group.datalake_users_internal.name
  policy_arn = aws_iam_policy.lf_governed_table_policy.arn
}

# ==============================================================================
# Grupo 3: datalake-users-external
# Permissões: acesso compartilhado via API/interface; apenas business tables
# ==============================================================================

resource "aws_iam_group" "datalake_users_external" {
  name = "datalake-users-external"
}

resource "aws_iam_group_policy" "datalake_users_external_assume_role" {
  name   = "AllowAssumeExternalUserRole"
  group  = aws_iam_group.datalake_users_external.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.datalake_users_external_lf_role.arn
      }
    ]
  })
}

resource "aws_iam_group_policy" "datalake_users_external_basic" {
  name   = "DatalakeExternalUserBasic"
  group  = aws_iam_group.datalake_users_external.name
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
          "glue:GetPartitions",
          "lakeformation:GetResourceLFTags",
          "lakeformation:ListLFTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "datalake_users_external_athena" {
  group      = aws_iam_group.datalake_users_external.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaReadOnlyAccess"
}
