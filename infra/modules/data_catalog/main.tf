#===============================================================================
# Data Catalog Module — Raw Database Tables
#===============================================================================

module "db_raw" {
  source = "./db_raw"

  tables    = var.tables
  databases = var.databases
  buckets   = var.buckets

  depends_on = [
    aws_lakeformation_permissions.grant_admins_database_raw,
    aws_lakeformation_permissions.grant_dml_db_raw,
  ]
}
