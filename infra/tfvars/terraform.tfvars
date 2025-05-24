control_account = "331504768406"

# lake_admin_arn = "arn:aws:iam::331504768406:user/lake-admin"
# datalake_role_arn = "arn:aws:iam::331504768406:role/role-datalake-analytics"

datalake_role_name = "role-datalake-analytics"
datalake_policy_name = "datalake-policy"

buckets = {
  workspace = "lakehouse-workspace-331504768406"
  raw       = "lakehouse-raw-331504768406"
  refined   = "lakehouse-refined-331504768406"
  business  = "lakehouse-business-331504768406"
}

databases = {
  raw      = "raw_db"
  refined  = "refined_db"
  business = "business_db"
}

tables = {
  control      = "etl_control"
  data_quality = "data_quality_metrics"
}



