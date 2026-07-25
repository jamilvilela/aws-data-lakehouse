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
      # (1) Permissões gerais de Lake Formation / Glue / S3 (já existia)
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
      },
      # (2) IAM para a role/policy de analytics 
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:ListPolicyVersions",
          "iam:UpdateAssumeRolePolicy"
        ]
        Resource = [
          var.datalake_role_arn,
          var.datalake_policy_arn
        ]
      },
      # (3) IAM para GRUPOS do datalake 
      {
        Effect = "Allow"
        Action = [
          "iam:GetGroup",
          "iam:CreateGroup",
          "iam:DeleteGroup",
          "iam:GetGroupPolicy",
          "iam:PutGroupPolicy",
          "iam:DeleteGroupPolicy",
          "iam:AttachGroupPolicy",
          "iam:DetachGroupPolicy",
          "iam:ListAttachedGroupPolicies"
        ]
        Resource = [
          aws_iam_group.datalake_admins.arn,
          aws_iam_group.datalake_users_internal.arn,
          aws_iam_group.datalake_users_external.arn
        ]
      },
      # (4) IAM para USUÁRIOS do datalake 
      {
        Effect = "Allow"
        Action = [
          "iam:GetUser",
          "iam:CreateUser",
          "iam:DeleteUser",
          "iam:GetLoginProfile",
          "iam:CreateLoginProfile",
          "iam:UpdateLoginProfile",
          "iam:DeleteLoginProfile"
        ]
        Resource = [
          aws_iam_user.datalake_admin.arn,
          aws_iam_user.datalake_user1.arn
        ]
      },
      # (5) Membership user <-> group (GroupMembership)
      {
        Effect = "Allow"
        Action = [
          "iam:AddUserToGroup",
          "iam:RemoveUserFromGroup"
        ]
        Resource = "*"
      },
      # (6) IAM para as ROLES LF (corrige ListRolePolicies nas roles LF)
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy"
        ]
        Resource = [
          aws_iam_role.datalake_admins_lf_role.arn,
          aws_iam_role.datalake_users_internal_lf_role.arn,
          aws_iam_role.datalake_users_external_lf_role.arn,
          aws_iam_role.lakeformation_workflow_role.arn
        ]
      },
      # (7) IAM para as policies auxiliares (LF* policies)
      {
        Effect = "Allow"
        Action = [
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:ListPolicyVersions"
        ]
        Resource = [
          aws_iam_policy.lf_workflow_pass_role_policy.arn,
          aws_iam_policy.lf_user_pass_role_policy.arn,
          aws_iam_policy.lf_ram_access_policy.arn,
          aws_iam_policy.lf_governed_table_policy.arn
        ]
      },
      # (8) 🔹 Permissões para consultar a service-linked role do Lake Formation      
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:PutRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:CreateServiceLinkedRole",
          "iam:PassRole"
        ]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"
      },
      # (9) 🔹 SQS — gerenciar filas
      {
        Effect = "Allow"
        Action = [
          "sqs:ListQueues",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:CreateQueue",
          "sqs:DeleteQueue",
          "sqs:SetQueueAttributes",
          "sqs:TagQueue",
          "sqs:ListQueueTags"
        ]
        Resource = "*"
      },
      # (10) 🔹 SNS — gerenciar tópicos e assinaturas
      {
        Effect = "Allow"
        Action = [
          "sns:ListTopics",
          "sns:ListSubscriptions",
          "sns:GetTopicAttributes",
          "sns:Publish",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:SetTopicAttributes",
          "sns:TagResource",
          "sns:ListTagsForResource"
        ]
        Resource = "*"
      },
      # (11) 🔹 Athena — executar e visualizar consultas
      {
        Effect = "Allow"
        Action = [
          "athena:StartQueryExecution",
          "athena:StopQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults",
          "athena:ListWorkGroups",
          "athena:GetWorkGroup",
          "athena:ListDataCatalogs",
          "athena:GetDataCatalog",
          "athena:ListDatabases",
          "athena:ListTableMetadata",
          "athena:GetTableMetadata",
          "athena:GetNamedQuery",
          "athena:ListNamedQueries",
          "athena:CreateNamedQuery",
          "athena:DeleteNamedQuery"
        ]
        Resource = "*"
      },
      # (12) 🔹 Kinesis Data Streams — consultar streams
      {
        Effect = "Allow"
        Action = [
          "kinesis:ListStreams",
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:PutRecord",
          "kinesis:ListShards",
          "kinesis:ListTagsForStream",
          "kinesis:CreateStream",
          "kinesis:DeleteStream",
          "kinesis:UpdateShardCount",
          "kinesis:RegisterStreamConsumer",
          "kinesis:DeregisterStreamConsumer",
          "kinesis:ListStreamConsumers",
          "kinesis:DescribeStreamConsumer"
        ]
        Resource = "*"
      },
      # (13) 🔹 Firehose — gerenciar delivery streams
      {
        Effect = "Allow"
        Action = [
          "firehose:ListDeliveryStreams",
          "firehose:DescribeDeliveryStream",
          "firehose:CreateDeliveryStream",
          "firehose:DeleteDeliveryStream",
          "firehose:UpdateDestination",
          "firehose:PutRecord",
          "firehose:PutRecordBatch",
          "firehose:ListTagsForDeliveryStream",
          "firehose:TagDeliveryStream"
        ]
        Resource = "*"
      },
      # (14) 🔹 Managed Service for Apache Flink (ex-Kinesis Analytics / Flink)
      {
        Effect = "Allow"
        Action = [
          "kinesisanalytics:ListApplications",
          "kinesisanalytics:DescribeApplication",
          "kinesisanalytics:CreateApplication",
          "kinesisanalytics:DeleteApplication",
          "kinesisanalytics:UpdateApplication",
          "kinesisanalytics:StartApplication",
          "kinesisanalytics:StopApplication",
          "kinesisanalytics:ListTagsForResource",
          "kinesisanalytics:TagResource",
          "kinesisanalytics:AddApplicationInput",
          "kinesisanalytics:AddApplicationOutput",
          "kinesisanalytics:AddApplicationReferenceDataSource",
          "kinesisanalyticsv2:ListApplications",
          "kinesisanalyticsv2:DescribeApplication",
          "kinesisanalyticsv2:CreateApplication",
          "kinesisanalyticsv2:DeleteApplication",
          "kinesisanalyticsv2:UpdateApplication",
          "kinesisanalyticsv2:StartApplication",
          "kinesisanalyticsv2:StopApplication",
          "kinesisanalyticsv2:ListTagsForResource",
          "kinesisanalyticsv2:TagResource"
        ]
        Resource = "*"
      },
      # (15) 🔹 RDS / Aurora — administrar (inclui global clusters)
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:DescribeGlobalClusters",
          "rds:ListTagsForResource",
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:RebootDBInstance",
          "rds:CreateDBCluster",
          "rds:DeleteDBCluster",
          "rds:ModifyDBCluster",
          "rds:FailoverDBCluster",
          "rds:StartDBCluster",
          "rds:StopDBCluster",
          "rds:DescribeDBSubnetGroups",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBClusterParameters",
          "rds:ModifyDBClusterParameterGroup",
          "rds:ResetDBClusterParameterGroup",
          "rds:CreateDBClusterParameterGroup",
          "rds:DeleteDBClusterParameterGroup",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:ModifyDBSubnetGroup",
          "rds:DescribeDBClusterSnapshots",
          "rds:CreateDBClusterSnapshot",
          "rds:DeleteDBClusterSnapshot",
          "rds:RestoreDBClusterFromSnapshot",
          "rds:DescribeEventSubscriptions",
          "rds:CreateEventSubscription",
          "rds:DeleteEventSubscription",
          "rds:DescribePendingMaintenanceActions",
          "rds:DescribeDBClusterEndpoints",
          "rds:CreateDBClusterEndpoint",
          "rds:DeleteDBClusterEndpoint",
          "rds:ModifyDBClusterEndpoint"
        ]
        Resource = "*"
      },
      # (16) 🔹 AWS Batch — ver e executar jobs
      {
        Effect = "Allow"
        Action = [
          "batch:DescribeComputeEnvironments",
          "batch:DescribeJobDefinitions",
          "batch:DescribeJobQueues",
          "batch:DescribeJobs",
          "batch:ListJobs",
          "batch:SubmitJob",
          "batch:TerminateJob",
          "batch:CancelJob",
          "batch:CreateComputeEnvironment",
          "batch:DeleteComputeEnvironment",
          "batch:UpdateComputeEnvironment",
          "batch:CreateJobQueue",
          "batch:DeleteJobQueue",
          "batch:UpdateJobQueue",
          "batch:RegisterJobDefinition",
          "batch:DeregisterJobDefinition",
          "batch:ListTagsForResource",
          "batch:TagResource"
        ]
        Resource = "*"
      },
      # (17) 🔹 CloudWatch — métricas, dashboards, alarmes e logs
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:SetAlarmState",
          "cloudwatch:DescribeAlarmHistory",
          "cloudwatch:ListDashboards",
          "cloudwatch:GetDashboard",
          "cloudwatch:PutDashboard",
          "cloudwatch:DeleteDashboards",
          "cloudwatch:ListTagsForResource",
          "cloudwatch:TagResource",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:GetQueryResults",
          "logs:DescribeMetricFilters",
          "logs:PutMetricFilter",
          "logs:DeleteMetricFilter",
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:ListTagsLogGroup",
          "logs:TagLogGroup"
        ]
        Resource = "*"
      },
      # (18) 🔹 Lambda — listar, visualizar, testar e executar funções
      {
        Effect = "Allow"
        Action = [
          "lambda:ListFunctions",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:InvokeAsync",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:UpdateFunctionConfiguration",
          "lambda:UpdateFunctionCode",
          "lambda:PublishVersion",
          "lambda:ListVersionsByFunction",
          "lambda:ListAliases",
          "lambda:GetAlias",
          "lambda:CreateAlias",
          "lambda:UpdateAlias",
          "lambda:DeleteAlias",
          "lambda:GetEventSourceMapping",
          "lambda:ListEventSourceMappings",
          "lambda:CreateEventSourceMapping",
          "lambda:UpdateEventSourceMapping",
          "lambda:DeleteEventSourceMapping",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "lambda:ListTags",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:GetLayerVersion",
          "lambda:ListLayerVersions",
          "lambda:PublishLayerVersion",
          "lambda:DeleteLayerVersion"
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

resource "aws_iam_role_policy_attachment" "datalake_admins_lf_athena" {
  role       = aws_iam_role.datalake_admins_lf_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}
