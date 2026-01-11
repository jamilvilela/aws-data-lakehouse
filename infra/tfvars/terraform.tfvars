# terraform plan -var-file="tfvars/terraform.tfvars" 
# terraform apply -var-file="tfvars/terraform.tfvars" -auto-approve
control_account = "331504768406"

datalake_role_name = "role-datalake-analytics"
datalake_policy_name = "datalake-policy"

buckets = {
  workspace = "lakehouse-workspace-331504768406"
  landing   = "lakehouse-landing-331504768406"
  raw       = "lakehouse-raw-331504768406"
  trusted   = "lakehouse-trusted-331504768406"
  business  = "lakehouse-business-331504768406"
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

users = {
  datalake_admin = {
    name = "datalake-admin"
  }
  datalake_user1 = {
    name = "datalake-user-01"
  }
}

