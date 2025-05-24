resource "aws_glue_catalog_table" "dataquality_metrics" {
  depends_on    = [aws_glue_catalog_database.db_raw]
  name          = var.tables.data_quality
  database_name = var.databases.raw
  catalog_id    = var.control_account
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    classification = "parquet"
  }
  partition_keys {
    name = "reference_date"
    type = "date"
  }
  storage_descriptor {
    location      = "${var.buckets.raw}/tables/${var.tables.data_quality}/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = var.tables.data_quality
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }
    columns {
      name    = "database"
      type    = "string"
      comment = "Name of the evaluated database"
    }
    columns {
      name    = "processing_timestamp"
      type    = "timestamp"
      comment = "Processing date and time"
    }
    columns {
      name    = "metric"
      type    = "string"
      comment = "Evaluated metric"
    }
    columns {
      name    = "failure_reason"
      type    = "string"
      comment = "Reason for evaluation failure"
    }
    columns {
      name    = "status"
      type    = "string"
      comment = "Evaluation status"
    }
    columns {
      name    = "partition"
      type    = "string"
      comment = "Evaluated table partition identification"
    }
    columns {
      name    = "rule"
      type    = "string"
      comment = "Applied evaluation rule"
    }
    columns {
      name    = "table"
      type    = "string"
      comment = "Name of the evaluated table"
    }
    columns {
      name    = "technology"
      type    = "string"
      comment = "Name of the evaluated database technology"
    }
  }
}
