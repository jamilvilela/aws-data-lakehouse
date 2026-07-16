# ------------------------------------------------------------------------------
# tbl_aircraft_positions — Aircraft positions (high volume, streaming)
# Source: DMS CDC from flight_radar.aircraft_positions (Aurora PostgreSQL)
# Format: Delta Lake
# PK: position_id, recorded_at
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_aircraft_positions" {
  name          = var.tables.tbl_aircraft_positions
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/tbl_aircraft_positions/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library
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
