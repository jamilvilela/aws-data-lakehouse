module "iam" {
  source               = "./modules/iam"
  control_account      = var.control_account
  datalake_role_name   = var.datalake_role_name
  datalake_policy_name = var.datalake_policy_name
}

module "s3" {
  source           = "./modules/s3"
  buckets = var.buckets
}

module "lakeformation" {
  source                 = "./modules/lakeformation"
  control_account        = var.control_account
  users                  = var.users
  databases              = var.databases
  tables                 = var.tables
  datalake_role_arn      = module.iam.datalake_role_arn
  datalake_policy_name   = var.datalake_policy_name
  workspace_bucket_arn   = module.s3.workspace_bucket_arn
  raw_bucket_arn         = module.s3.raw_bucket_arn
  refined_bucket_arn     = module.s3.refined_bucket_arn
  business_bucket_arn    = module.s3.business_bucket_arn
  lake_admin_arn         = "arn:aws:iam::331504768406:user/lake-admin"

  depends_on = [module.iam, module.s3]
}

module "aws_data_catalog" {
  source                 = "./modules/aws_data_catalog"
  control_account        = var.control_account
  datalake_role_arn      = module.iam.datalake_role_arn
  buckets                = var.buckets
  databases              = var.databases
  tables                 = var.tables
  # lake_admin_arn         = module.lakeformation.datalake_admin_arn
  lake_admin_arn         = "arn:aws:iam::331504768406:user/lake-admin"

  depends_on = [module.iam, module.lakeformation, module.s3]
}