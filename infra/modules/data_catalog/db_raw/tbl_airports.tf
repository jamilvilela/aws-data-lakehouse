# ------------------------------------------------------------------------------
# tbl_airports — Airports reference
# Source: DMS CDC from flight_radar.airports (Aurora PostgreSQL)
# Format: Delta Lake
# PK: icao_code (natural key)
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_airports" {
  name          = var.tables.tbl_airports
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
    location      = "s3://${var.buckets.raw}/tables/tbl_airports/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "id"
      type    = "int"
      comment = "Airport internal ID (PK)"
    }
    columns {
      name    = "ident"
      type    = "string"
      comment = "Airport identifier code"
    }
    columns {
      name    = "type"
      type    = "string"
      comment = "Airport type (large_airport, medium_airport, small_airport, heliport...)"
    }
    columns {
      name    = "name"
      type    = "string"
      comment = "Airport name"
    }
    columns {
      name    = "latitude_deg"
      type    = "decimal(10,7)"
      comment = "Latitude in degrees"
    }
    columns {
      name    = "longitude_deg"
      type    = "decimal(10,7)"
      comment = "Longitude in degrees"
    }
    columns {
      name    = "elevation_ft"
      type    = "int"
      comment = "Elevation in feet"
    }
    columns {
      name    = "continent"
      type    = "string"
      comment = "Continent code"
    }
    columns {
      name    = "iso_country"
      type    = "string"
      comment = "ISO country code"
    }
    columns {
      name    = "iso_region"
      type    = "string"
      comment = "ISO region code"
    }
    columns {
      name    = "municipality"
      type    = "string"
      comment = "Municipality/city"
    }
    columns {
      name    = "scheduled_service"
      type    = "boolean"
      comment = "Has scheduled service?"
    }
    columns {
      name    = "icao_code"
      type    = "string"
      comment = "ICAO airport code (natural key)"
    }
    columns {
      name    = "iata_code"
      type    = "string"
      comment = "IATA airport code"
    }
    columns {
      name    = "gps_code"
      type    = "string"
      comment = "GPS code"
    }
    columns {
      name    = "local_code"
      type    = "string"
      comment = "Local airport code"
    }
    columns {
      name    = "home_link"
      type    = "string"
      comment = "Airport homepage URL"
    }
    columns {
      name    = "wikipedia_link"
      type    = "string"
      comment = "Wikipedia page URL"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (icao_code)"
    }
  }
}
