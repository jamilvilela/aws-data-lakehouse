# ------------------------------------------------------------------------------
# tbl_aircraft_types — Aircraft type catalog (models)
# Source: DMS CDC from flight_radar.aircraft_types (Aurora PostgreSQL)
# Format: Delta Lake
# PK: icao_code
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_aircraft_types" {
  name          = var.tables.tbl_aircraft_types
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/tbl_aircraft_types/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library
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
