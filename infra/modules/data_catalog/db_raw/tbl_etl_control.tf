# ------------------------------------------------------------------------------
# etl_control — Pipeline execution control table
# Source: Written by EtlControl class (Parquet append)
# Format: Parquet
# Partition: reference_date
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "etl_control" {
  name          = var.tables.etl_control
  database_name = var.databases.raw

  table_type = "EXTERNAL_TABLE"

  parameters = {
    classification  = "parquet"
    compressionType = "snappy"
  }

  partition_keys {
    name = "reference_date"
    type = "date"
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/etl_control/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "parquet"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
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
