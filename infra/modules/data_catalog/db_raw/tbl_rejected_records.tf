# Bronze: rejected records (Parquet, append-only, written by Glue ETL)
resource "aws_glue_catalog_table" "rejected_records" {
  name          = var.tables.rejected_records
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.parquet_parameters

  partition_keys {
    name = "event_date"
    type = "date"
  }

  storage_descriptor {
    location      = "${local.tables_root}/${var.tables.rejected_records}/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.parquet_ser_de.name
      serialization_library = local.parquet_ser_de.serialization_library
    }

    columns {
      name    = "execution_id"
      type    = "string"
      comment = "Unique execution UUID from the pipeline run"
    }
    columns {
      name    = "execution_timestamp"
      type    = "timestamp"
      comment = "Timestamp when the execution started (UTC)"
    }
    columns {
      name    = "source_database"
      type    = "string"
      comment = "Source database (typically db_raw)"
    }
    columns {
      name    = "source_table"
      type    = "string"
      comment = "Source table name (e.g. flights, aircraft, routes)"
    }
    columns {
      name    = "target_database"
      type    = "string"
      comment = "Target database (e.g. db_raw)"
    }
    columns {
      name    = "target_table"
      type    = "string"
      comment = "Target table name (e.g. tbl_flights)"
    }
    columns {
      name    = "reject_rule"
      type    = "string"
      comment = "Name of the validation rule that caused rejection (e.g. null_check, type_cast, enum_check)"
    }
    columns {
      name    = "reject_reason"
      type    = "string"
      comment = "Human-readable description of why the record was rejected"
    }
    columns {
      name    = "rejected_record_json"
      type    = "string"
      comment = "JSON string with rejected record columns as keys and values as values. Schema varies by source entity."
    }
  }
}
