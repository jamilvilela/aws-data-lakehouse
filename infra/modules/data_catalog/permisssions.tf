# Lake Formation catalog permissions by access level:
# - datalake-admins-lf-role: full access (DESCRIBE, SELECT, ALTER, INSERT, DELETE)
# - datalake-users-internal-lf-role: read access (DESCRIBE, SELECT)
# - datalake-users-external-lf-role: read access limited to the business database

# Database-level permissions

# Service role (Glue, EMR) - database visibility and table creation
resource "aws_lakeformation_permissions" "grant_datalake_database_raw" {
  permissions = ["DESCRIBE", "CREATE_TABLE"]
  principal   = var.datalake_role_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.raw
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_datalake_database_trusted" {
  permissions = ["DESCRIBE", "CREATE_TABLE"]
  principal   = var.datalake_role_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.trusted
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_datalake_database_business" {
  permissions = ["DESCRIBE", "CREATE_TABLE"]
  principal   = var.datalake_role_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Admins - all databases
resource "aws_lakeformation_permissions" "grant_admins_database_raw" {
  permissions = ["DESCRIBE", "CREATE_TABLE", "ALTER"]
  principal   = var.datalake_admins_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.raw
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_admins_database_trusted" {
  permissions = ["DESCRIBE", "CREATE_TABLE", "ALTER"]
  principal   = var.datalake_admins_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.trusted
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_admins_database_business" {
  permissions = ["DESCRIBE", "CREATE_TABLE", "ALTER"]
  principal   = var.datalake_admins_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Internal users - all databases (read)
resource "aws_lakeformation_permissions" "grant_internal_users_database_raw" {
  permissions = ["DESCRIBE"]
  principal   = var.datalake_users_internal_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.raw
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_internal_users_database_trusted" {
  permissions = ["DESCRIBE"]
  principal   = var.datalake_users_internal_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.trusted
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_internal_users_database_business" {
  permissions = ["DESCRIBE"]
  principal   = var.datalake_users_internal_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# External users - business database only
resource "aws_lakeformation_permissions" "grant_external_users_database_business" {
  permissions = ["DESCRIBE"]
  principal   = var.datalake_users_external_principal_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.business
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Table-level permissions

# Service role (Glue, EMR) - DML operations
resource "aws_lakeformation_permissions" "grant_dml_db_raw" {
  permissions = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal   = var.datalake_role_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

# Glue job role (flight radar pipeline) - DML operations on raw tables
resource "aws_lakeformation_permissions" "grant_job_dml_db_raw" {
  permissions = ["DESCRIBE", "SELECT", "INSERT", "DELETE"]
  principal   = var.datalake_job_role_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

# Glue job role (flight radar pipeline) - database visibility (DESCRIBE)
# required for the Spark session to resolve db_raw.<table> by name.
resource "aws_lakeformation_permissions" "grant_job_describe_db_raw" {
  permissions = ["DESCRIBE"]
  principal   = var.datalake_job_role_arn
  catalog_id  = var.control_account
  database {
    name = var.databases.raw
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_dml_db_trusted" {
  permissions = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal   = var.datalake_role_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.trusted
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_dml_db_business" {
  permissions = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal   = var.datalake_role_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Admins - all tables in all databases
resource "aws_lakeformation_permissions" "grant_admins_table_raw" {
  permissions = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal   = var.datalake_admins_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_admins_table_trusted" {
  permissions = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal   = var.datalake_admins_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.trusted
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_admins_table_business" {
  permissions = ["DESCRIBE", "SELECT", "ALTER", "INSERT", "DELETE"]
  principal   = var.datalake_admins_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# Internal users - read access to all tables
resource "aws_lakeformation_permissions" "grant_internal_users_table_raw" {
  permissions = ["DESCRIBE", "SELECT"]
  principal   = var.datalake_users_internal_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.raw
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_raw]
}

resource "aws_lakeformation_permissions" "grant_internal_users_table_trusted" {
  permissions = ["DESCRIBE", "SELECT"]
  principal   = var.datalake_users_internal_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.trusted
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_trusted]
}

resource "aws_lakeformation_permissions" "grant_internal_users_table_business" {
  permissions = ["DESCRIBE", "SELECT"]
  principal   = var.datalake_users_internal_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}

# External users - read access to business tables only
resource "aws_lakeformation_permissions" "grant_external_users_table_business" {
  permissions = ["DESCRIBE", "SELECT"]
  principal   = var.datalake_users_external_principal_arn
  catalog_id  = var.control_account
  table {
    database_name = var.databases.business
    wildcard      = true
  }
  depends_on = [aws_glue_catalog_database.db_business]
}
