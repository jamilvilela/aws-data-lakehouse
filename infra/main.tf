module "iam" {
  source               = "./modules/iam"
  control_account      = data.aws_caller_identity.current.account_id
  datalake_role_name   = var.datalake_role_name
  datalake_policy_name = var.datalake_policy_name
}

module "s3" {
  source  = "./modules/s3"
  buckets = local.buckets
}

module "lakeformation" {
  source                 = "./modules/lakeformation"
  control_account        = data.aws_caller_identity.current.account_id
  users                  = var.users
  databases              = var.databases
  tables                 = var.tables
  datalake_role_arn      = module.iam.datalake_role_arn
  datalake_policy_name   = var.datalake_policy_name
  workspace_bucket_arn   = module.s3.workspace_bucket_arn
  raw_bucket_arn         = module.s3.raw_bucket_arn
  trusted_bucket_arn     = module.s3.trusted_bucket_arn
  business_bucket_arn    = module.s3.business_bucket_arn
  # lake_admin_arn         = "arn:aws:iam::331504768406:user/lake-admin"
  lake_admin_arn         = data.aws_iam_user.lake_admin.arn

  depends_on = [module.iam, module.s3]
}

module "aws_data_catalog" {
  source                 = "./modules/data_catalog"
  control_account        = data.aws_caller_identity.current.account_id
  datalake_role_arn      = module.iam.datalake_role_arn
  buckets                = var.buckets
  databases              = var.databases
  tables                 = var.tables
  # lake_admin_arn         = "arn:aws:iam::331504768406:user/lake-admin"
  lake_admin_arn         = data.aws_iam_user.lake_admin.arn

  depends_on = [module.iam, module.lakeformation, module.s3]
}