datalake_role_name = "role-datalake-analytics"
datalake_policy_name = "datalake-policy"

buckets = {
  workspace = "lakehouse-workspace"
  landing   = "lakehouse-landing"
  raw       = "lakehouse-raw"
  trusted   = "lakehouse-trusted"
  business  = "lakehouse-business"
}

databases = {
  raw      = "db_raw"
  trusted  = "db_trusted"
  business = "db_business"
}

tables = {
  etl_control  = "etl_control"
  data_quality = "data_quality_metrics"
}

# Usuários criados no IAM
# Estes usuários serão adicionados automaticamente aos grupos correspondentes
users = {
  datalake_admin = {
    name = "datalake-admin"
  }
  datalake_user1 = {
    name = "datalake-user-01"
  }
}