# ------------------------------------------------------------------------------
# tbl_aircraft_positions — Aircraft positions (high volume, streaming)
# Source: DMS CDC from flight_radar.aircraft_positions (Aurora PostgreSQL)
# Format: Delta Lake
# PK: position_id, recorded_at
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_aircraft_positions" {
  name          = var.tables.tbl_aircraft_positions
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
    location      = "s3://${var.buckets.raw}/tables/tbl_aircraft_positions/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name    = "position_id"
      type    = "bigint"
      comment = "Position ID (PK)"
    }
    columns {
      name    = "aircraft_icao24"
      type    = "string"
      comment = "Aircraft ICAO24 address (FK → aircraft)"
    }
    columns {
      name    = "flight_id"
      type    = "bigint"
      comment = "Flight ID (FK → flights)"
    }
    columns {
      name    = "latitude"
      type    = "decimal(10,7)"
      comment = "Latitude"
    }
    columns {
      name    = "longitude"
      type    = "decimal(10,7)"
      comment = "Longitude"
    }
    columns {
      name    = "altitude_ft"
      type    = "int"
      comment = "Altitude in feet"
    }
    columns {
      name    = "velocity_kts"
      type    = "decimal(7,2)"
      comment = "Velocity in knots"
    }
    columns {
      name    = "heading"
      type    = "decimal(5,2)"
      comment = "Heading in degrees"
    }
    columns {
      name    = "vertical_rate_fpm"
      type    = "decimal(7,2)"
      comment = "Vertical rate in ft/min"
    }
    columns {
      name    = "on_ground"
      type    = "boolean"
      comment = "Is the aircraft on ground?"
    }
    columns {
      name    = "recorded_at"
      type    = "timestamp"
      comment = "Position recording timestamp"
    }
    columns {
      name    = "ingested_at"
      type    = "timestamp"
      comment = "Ingestion timestamp"
    }
    columns {
      name    = "dms_operation"
      type    = "string"
      comment = "DMS CDC operation (I/U/D)"
    }
    columns {
      name    = "dms_timestamp"
      type    = "timestamp"
      comment = "DMS capture timestamp"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (position_id_recorded_at)"
    }
  }
}
