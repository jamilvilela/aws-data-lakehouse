# ------------------------------------------------------------------------------
# tbl_flights — Flights fact table
# Source: DMS CDC from flight_radar.flights (Aurora PostgreSQL)
# Format: Delta Lake
# PK: flight_id
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_flights" {
  name          = var.tables.tbl_flights
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/tbl_flights/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library
    }

    columns {
      name    = "flight_id"
      type    = "bigint"
      comment = "Flight ID (PK)"
    }
    columns {
      name    = "flight_number"
      type    = "string"
      comment = "Flight number (e.g. AA1234)"
    }
    columns {
      name    = "airline_icao"
      type    = "string"
      comment = "Airline ICAO code (FK → airlines)"
    }
    columns {
      name    = "aircraft_icao24"
      type    = "string"
      comment = "Aircraft ICAO24 address (FK → aircraft)"
    }
    columns {
      name    = "origin_airport"
      type    = "string"
      comment = "Origin airport ICAO code"
    }
    columns {
      name    = "destination_airport"
      type    = "string"
      comment = "Destination airport ICAO code"
    }
    columns {
      name    = "scheduled_departure"
      type    = "timestamp"
      comment = "Scheduled departure time"
    }
    columns {
      name    = "scheduled_arrival"
      type    = "timestamp"
      comment = "Scheduled arrival time"
    }
    columns {
      name    = "actual_departure"
      type    = "timestamp"
      comment = "Actual departure time"
    }
    columns {
      name    = "actual_arrival"
      type    = "timestamp"
      comment = "Actual arrival time"
    }
    columns {
      name    = "status"
      type    = "string"
      comment = "Flight status (scheduled, active, landed, cancelled, diverted)"
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
      comment = "PK concatenation (flight_id)"
    }
  }
}
