# ------------------------------------------------------------------------------
# tbl_airlines — Airlines reference
# Source: DMS CDC from flight_radar.airlines (Aurora PostgreSQL)
# Format: Delta Lake
# PK: icao_code (natural key)
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_airlines" {
  name          = var.tables.tbl_airlines
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/tbl_airlines/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library
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
