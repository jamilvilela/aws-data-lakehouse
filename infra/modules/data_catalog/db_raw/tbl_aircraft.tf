# ------------------------------------------------------------------------------
# tbl_aircraft — Aircraft registry
# Source: DMS CDC from flight_radar.aircraft (Aurora PostgreSQL)
# Format: Delta Lake
# PK: icao24
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_aircraft" {
  name          = var.tables.tbl_aircraft
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
    location      = "s3://${var.buckets.raw}/tables/tbl_aircraft/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "icao24"
      type    = "string"
      comment = "ICAO aircraft address (hex)"
    }
    columns {
      name    = "registration"
      type    = "string"
      comment = "Aircraft registration/tail number"
    }
    columns {
      name    = "aircraft_type"
      type    = "string"
      comment = "Aircraft type ICAO code (e.g. B738, A320)"
    }
    columns {
      name    = "serial_number"
      type    = "string"
      comment = "Manufacturer serial number"
    }
    columns {
      name    = "operator_icao"
      type    = "string"
      comment = "Operator ICAO code"
    }
    columns {
      name    = "operator_name"
      type    = "string"
      comment = "Operator name"
    }
    columns {
      name    = "year_built"
      type    = "int"
      comment = "Year of manufacture"
    }
    columns {
      name    = "created_at"
      type    = "timestamp"
      comment = "Record creation timestamp"
    }
    columns {
      name    = "updated_at"
      type    = "timestamp"
      comment = "Record last update timestamp"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (icao24)"
    }
  }
}
