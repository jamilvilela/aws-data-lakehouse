# ------------------------------------------------------------------------------
# Local variables for common Glue Catalog Table configurations
# These values are shared across all tables in the raw database to reduce
# duplication and centralize changes.
# ------------------------------------------------------------------------------

locals {
  # ── Common settings for all tables ─────────────────────────────────────
  table_type = "EXTERNAL_TABLE"

  input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
  output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

  # ── Delta Lake tables (DMS CDC from Aurora PostgreSQL) ─────────────────
  delta_parameters = {
    classification  = "delta"
    table_type      = "delta"
    compressionType = "snappy"
  }

  delta_partition_key = {
    name = "event_date"
    type = "date"
  }

  delta_ser_de = {
    name                  = "DeltaLakeSerDe"
    serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
  }

  # ── Parquet tables (control/quality) ───────────────────────────────────
  parquet_parameters = {
    classification  = "parquet"
    compressionType = "snappy"
  }

  parquet_partition_key = {
    name = "reference_date"
    type = "date"
  }

  parquet_ser_de = {
    name                  = "parquet"
    serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
  }
}
