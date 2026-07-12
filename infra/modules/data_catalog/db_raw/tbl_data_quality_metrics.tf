# ------------------------------------------------------------------------------
# data_quality_metrics — Data quality metrics table
# Source: Written by QualityMetrics class (Parquet append)
# Format: Parquet
# Partition: reference_date
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "data_quality_metrics" {
  name          = var.tables.data_quality
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
    location      = "s3://${var.buckets.raw}/tables/data_quality_metrics/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "parquet"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "database"
      type    = "string"
      comment = "Evaluated database"
    }
    columns {
      name    = "table"
      type    = "string"
      comment = "Evaluated table"
    }
    columns {
      name    = "processing_timestamp"
      type    = "timestamp"
      comment = "Processing timestamp"
    }
    columns {
      name    = "metric"
      type    = "string"
      comment = "Evaluated metric"
    }
    columns {
      name    = "rule"
      type    = "string"
      comment = "Applied rule"
    }
    columns {
      name    = "status"
      type    = "string"
      comment = "passed, failed"
    }
    columns {
      name    = "failure_reason"
      type    = "string"
      comment = "Failure reason"
    }
    columns {
      name    = "partition"
      type    = "string"
      comment = "Evaluated partition"
    }
    columns {
      name    = "technology"
      type    = "string"
      comment = "Technology (e.g. glue)"
    }
    columns {
      name    = "reference_date"
      type    = "date"
      comment = "Partition date"
    }
  }
}
