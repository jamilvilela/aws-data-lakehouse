# ------------------------------------------------------------------------------
# tbl_airlines — Airlines reference
# Source: DMS CDC from flight_radar.airlines (Aurora PostgreSQL)
# Format: Delta Lake
# PK: icao_code (natural key)
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_airlines" {
  name          = var.tables.tbl_airlines
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
    location      = "s3://${var.buckets.raw}/tables/tbl_airlines/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "id"
      type    = "int"
      comment = "Airline internal ID (PK)"
    }
    columns {
      name    = "name"
      type    = "string"
      comment = "Airline name"
    }
    columns {
      name    = "alias"
      type    = "string"
      comment = "Airline alias/alternative name"
    }
    columns {
      name    = "iata_code"
      type    = "string"
      comment = "IATA airline code (2-letter)"
    }
    columns {
      name    = "icao_code"
      type    = "string"
      comment = "ICAO airline code (3-letter, natural key)"
    }
    columns {
      name    = "callsign"
      type    = "string"
      comment = "Airline callsign"
    }
    columns {
      name    = "country"
      type    = "string"
      comment = "Country of incorporation"
    }
    columns {
      name    = "is_active"
      type    = "boolean"
      comment = "Is the airline active?"
    }
    columns {
      name    = "created_at"
      type    = "timestamp"
      comment = "Record creation timestamp"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (icao_code)"
    }
  }
}
