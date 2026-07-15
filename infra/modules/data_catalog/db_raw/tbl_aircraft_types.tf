# ------------------------------------------------------------------------------
# tbl_aircraft_types — Aircraft type catalog (models)
# Source: DMS CDC from flight_radar.aircraft_types (Aurora PostgreSQL)
# Format: Delta Lake
# PK: icao_code
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_aircraft_types" {
  name          = var.tables.tbl_aircraft_types
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
    location      = "s3://${var.buckets.raw}/tables/tbl_aircraft_types/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "icao_code"
      type    = "string"
      comment = "ICAO aircraft type code (e.g. B738, A320)"
    }
    columns {
      name    = "iata_code"
      type    = "string"
      comment = "IATA aircraft type code (e.g. 738, 320)"
    }
    columns {
      name    = "name"
      type    = "string"
      comment = "Aircraft model name"
    }
    columns {
      name    = "manufacturer"
      type    = "string"
      comment = "Manufacturer name"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (icao_code)"
    }
  }
}
