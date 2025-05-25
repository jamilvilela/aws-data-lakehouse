resource "aws_glue_catalog_table" "etl_execution_control" {
  depends_on   = [aws_glue_catalog_database.db_raw]
  name         = var.tables.etl_control
  description  = "ETL execution control table"
  database_name = var.databases.raw
  catalog_id    = var.control_account
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    classification = "parquet"
  }

  partition_keys {
    name    = "reference_date"
    type    = "date"
    comment = "Reference date of the execution"
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/${var.tables.etl_control}/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = var.tables.etl_control
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }
   
    columns {
      name    = "target_table_name"
      type    = "string"
      comment = "Name of the target table"
    }
    columns {
      name    = "execution_start_timestamp"
      type    = "timestamp"
      comment = "Start datetime of the execution"
    }
    columns {
      name    = "execution_end_timestamp"
      type    = "timestamp"
      comment = "End datetime of the execution"
    }
    columns {
      name    = "target_partition"
      type    = "string"
      comment = "Partition of the target table"
    }
    columns {
      name    = "source_tables"
      type    = "array<struct<source_table_name:string,source_partition:string>>"
      comment = "Source tables data"
    }
  }
}
