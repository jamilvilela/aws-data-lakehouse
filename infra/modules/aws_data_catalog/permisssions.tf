resource "aws_lakeformation_permissions" "grant_dml_db_raw" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_role_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_dml_db_refined" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_role_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.refined
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_refined]
}

resource "aws_lakeformation_permissions" "grant_dml_db_business" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_role_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

// Adicionar permissões para o usuário lake_admin para consultas via Athena
resource "aws_lakeformation_permissions" "grant_select_lake_admin_raw" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.lake_admin_arn
  catalog_id      = var.control_account

  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_select_lake_admin_refined" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.lake_admin_arn                     
  catalog_id      = var.control_account

  table {
    database_name = var.databases.refined
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_refined]
}

resource "aws_lakeformation_permissions" "grant_select_lake_admin_business" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.lake_admin_arn
  catalog_id      = var.control_account

  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}
