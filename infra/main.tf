module "iam" {
  source               = "./modules/iam"
  control_account      = var.control_account
  datalake_role_name   = var.datalake_role_name
  datalake_policy_name = var.datalake_policy_name
}

module "s3" {
  source           = "./modules/s3"
  buckets = var.buckets
  # workspace_bucket = var.buckets.workspace
  # raw_bucket       = var.buckets.raw
  # refined_bucket   = var.buckets.refined
  # business_bucket  = var.buckets.business
}

module "lakeformation" {
  source                 = "./modules/lakeformation"
  control_account        = var.control_account
  users                 = var.users
  datalake_role_arn      = module.iam.datalake_role_arn
  datalake_policy_name   = var.datalake_policy_name
  databases = var.databases
  tables = var.tables
  workspace_bucket_arn       = module.s3.workspace_bucket_arn
  raw_bucket_arn             = module.s3.raw_bucket_arn
  refined_bucket_arn         = module.s3.refined_bucket_arn
  business_bucket_arn        = module.s3.business_bucket_arn

  depends_on = [module.iam, module.s3]
}

module "aws_data_catalog" {
  source                 = "./modules/aws_data_catalog"
  control_account        = var.control_account
  datalake_role_arn     = module.iam.datalake_role_arn
  buckets                = var.buckets
  databases              = var.databases
  tables                = var.tables
  # workspace_bucket       = var.buckets.workspace
  # raw_bucket             = var.buckets.raw
  # refined_bucket         = var.buckets.refined
  # business_bucket        = var.buckets.business
  # databases_raw            = var.databases.raw
  # databases_refined        = var.databases.refined
  # databases_business       = var.databases.business
  # control_table_name     = var.tables.etl_control
  # data_quality_table_name = var.tables.data_quality
  lake_admin_arn          = module.lakeformation.datalake_admin_arn

  depends_on = [module.iam, module.lakeformation, module.s3]
}