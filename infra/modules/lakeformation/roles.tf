################################################################################
# IAM Roles para Lake Formation - Uma por grupo lógico de usuários
# 
# Estas roles são usadas como principal no Lake Formation porque LF não suporta
# IAM Groups como principal. Os usuários assumem estas roles via sts:AssumeRole
# através de políticas de grupo (vide groups.tf).
# 
# Trust policy: permite que qualquer principal da conta assuma a role
# (refinado depois com políticas de grupo específicas).
################################################################################

# ==============================================================================
# Role para administradores do Data Lake
# ==============================================================================

resource "aws_iam_role" "datalake_admins_lf_role" {
  name               = "datalake-admins-lf-role"
  description        = "Role para administradores do Data Lake (Lake Formation principal)"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Inline policy para que a role tenha permissões admin no Lake Formation
# quando for assumida
resource "aws_iam_role_policy" "datalake_admins_lf_inline_policy" {
  name = "AdminLakeFormationPolicy"
  role = aws_iam_role.datalake_admins_lf_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lakeformation:*",
          "glue:*",
          "s3:*",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeNetworkInterfaces",
          "iam:ListUsers",
          "iam:ListRoles",
          "iam:ListGroups",
          "iam:GetRole",
          "iam:GetUser",
          "iam:GetGroup",
          "cloudtrail:LookupEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# ==============================================================================
# Role para usuários internos do Data Lake
# ==============================================================================

resource "aws_iam_role" "datalake_users_internal_lf_role" {
  name               = "datalake-users-internal-lf-role"
  description        = "Role para usuários internos do Data Lake (Lake Formation principal)"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Inline policy para acesso de leitura ao Lake Formation
resource "aws_iam_role_policy" "datalake_users_internal_lf_inline_policy" {
  name = "InternalUserLakeFormationPolicy"
  role = aws_iam_role.datalake_users_internal_lf_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lakeformation:GetDataAccess",
          "lakeformation:GetResourceLFTags",
          "lakeformation:ListLFTags",
          "lakeformation:GetLFTag",
          "lakeformation:SearchTablesByLFTag",
          "lakeformation:SearchDatabasesByLFTags",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersions",
          "glue:SearchTables",
          "glue:GetPartitions",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

# ==============================================================================
# Role para usuários externos do Data Lake
# ==============================================================================

resource "aws_iam_role" "datalake_users_external_lf_role" {
  name               = "datalake-users-external-lf-role"
  description        = "Role para usuários externos do Data Lake (Lake Formation principal)"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Inline policy com acesso muito restrito (apenas business database, leitura)
resource "aws_iam_role_policy" "datalake_users_external_lf_inline_policy" {
  name = "ExternalUserLakeFormationPolicy"
  role = aws_iam_role.datalake_users_external_lf_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lakeformation:GetDataAccess",
          "lakeformation:GetResourceLFTags",
          "lakeformation:ListLFTags",
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersions",
          "glue:SearchTables",
          "glue:GetPartitions",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

# ==============================================================================
# Role para workflows do Lake Formation (serviço)
# ==============================================================================

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