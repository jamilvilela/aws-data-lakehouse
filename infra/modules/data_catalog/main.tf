#===============================================================================
# Data Catalog Module — Bronze Layer (Raw Database Tables)
# As tabelas bronze armazenam os dados exatamente como recebidos da origem,
# com colunas de metadados CDC para auditoria e idempotência (cdc_operation,
# cdc_timestamp, cod_unico). Particionadas por event_date para manutenção
# eficiente e suporte a Delta Lake.
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
