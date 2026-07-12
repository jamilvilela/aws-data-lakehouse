# ------------------------------------------------------------------------------
# tbl_countries — Countries reference table
# Source: DMS CDC from flight_radar.countries (Aurora PostgreSQL)
# Format: Delta Lake
# PK: id
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_countries" {
  name          = var.tables.tbl_countries
  database_name = var.databases.raw

  table_type = "EXTERNAL_TABLE"

  parameters = {
    classification  = "delta"
    table_type      = "delta"
    compressionType = "snappy"
  }

  partition_keys {
    name = "event_date"
    type = "date"
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/tbl_countries/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "id"
      type    = "int"
      comment = "Country internal ID (PK)"
    }
    columns {
      name    = "code"
      type    = "string"
      comment = "ISO 2-letter country code"
    }
    columns {
      name    = "name"
      type    = "string"
      comment = "Country name"
    }
    columns {
      name    = "continent"
      type    = "string"
      comment = "Continent code"
    }
    columns {
      name    = "wikipedia_link"
      type    = "string"
      comment = "Wikipedia page URL"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (id)"
    }
  }
}
