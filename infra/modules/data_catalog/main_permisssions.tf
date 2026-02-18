################################################################################
# Lake Formation Permissions
# 
# Modelo baseado em roles:
# - datalake-admins-lf-role: admin full access (DESCRIBE, SELECT, ALTER, INSERT, DELETE)
# - datalake-users-internal-lf-role: read access (DESCRIBE, SELECT)
# - datalake-users-external-lf-role: limited read access (business database only)
################################################################################

# ==============================================================================
# Database-level permissions
# ==============================================================================

# Admins - todos databases
resource "aws_lakeformation_permissions" "grant_admins_database_raw" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_admins_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.raw
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_admins_database_trusted" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_admins_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.trusted
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_admins_database_business" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_admins_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Internal users - todos databases (leitura)
resource "aws_lakeformation_permissions" "grant_internal_users_database_raw" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_users_internal_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.raw
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_internal_users_database_trusted" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_users_internal_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.trusted
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_internal_users_database_business" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_users_internal_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# External users - apenas business database
resource "aws_lakeformation_permissions" "grant_external_users_database_business" {
  permissions     = ["DESCRIBE"]
  principal       = var.datalake_users_external_principal_arn
  catalog_id      = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# ==============================================================================
# Table-level permissions
# ==============================================================================

# Service role (Glue, EMR) - DML operations
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

resource "aws_lakeformation_permissions" "grant_dml_db_trusted" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_role_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.trusted
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
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

# Admins - todas as tabelas em todos databases
resource "aws_lakeformation_permissions" "grant_admins_table_raw" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_admins_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_admins_table_trusted" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_admins_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.trusted
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_admins_table_business" {
  permissions     = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal       = var.datalake_admins_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Internal users - leitura em todas as tabelas
resource "aws_lakeformation_permissions" "grant_internal_users_table_raw" {
  permissions     = ["DESCRIBE", "SELECT"]
  principal       = var.datalake_users_internal_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_internal_users_table_trusted" {
  permissions     = ["DESCRIBE", "SELECT"]
  principal       = var.datalake_users_internal_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.trusted
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_internal_users_table_business" {
  permissions     = ["DESCRIBE", "SELECT"]
  principal       = var.datalake_users_internal_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# External users - leitura apenas em business
resource "aws_lakeformation_permissions" "grant_external_users_table_business" {
  permissions     = ["DESCRIBE", "SELECT"]
  principal       = var.datalake_users_external_principal_arn
  catalog_id      = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}
