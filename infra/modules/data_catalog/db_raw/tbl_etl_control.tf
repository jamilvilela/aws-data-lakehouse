# ------------------------------------------------------------------------------
# etl_control — Pipeline execution control table
# Source: Written by EtlControl class (Parquet append)
# Format: Parquet
# Partition: reference_date
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "etl_control" {
  name          = var.tables.etl_control
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.parquet_parameters

  partition_keys {
    name = local.parquet_partition_key.name
    type = local.parquet_partition_key.type
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/etl_control/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.parquet_ser_de.name
      serialization_library = local.parquet_ser_de.serialization_library
    }

    columns {
      name    = "execution_id"
      type    = "string"
      comment = "Execution UUID"
    }
    columns {
      name    = "job_name"
      type    = "string"
      comment = "Glue Job name"
    }
    columns {
      name    = "source"
      type    = "string"
      comment = "Processed source (e.g. flights)"
    }
    columns {
      name    = "execution_start"
      type    = "timestamp"
      comment = "Execution start"
    }
    columns {
      name    = "execution_end"
      type    = "timestamp"
      comment = "Execution end"
    }
    columns {
      name    = "status"
      type    = "string"
      comment = "running, success, failed"
    }
    columns {
      name    = "records_read"
      type    = "bigint"
      comment = "Records read"
    }
    columns {
      name    = "records_written"
      type    = "bigint"
      comment = "Records written to raw"
    }
    columns {
      name    = "records_rejected"
      type    = "bigint"
      comment = "Rejected records"
    }
    columns {
      name    = "target_partition"
      type    = "string"
      comment = "Target partition (e.g. event_date=)"
    }
    columns {
      name    = "error_message"
      type    = "string"
      comment = "Error message (if any)"
    }
  }
}
