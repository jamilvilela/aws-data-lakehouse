# Bronze: aircraft type catalog (Delta Lake, CDC from flight_radar.aircraft_types)
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
    location      = "${local.tables_root}/${var.tables.tbl_aircraft_types}/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library

      parameters = {
        "serialization.format" = "1"
        "path"                 = "${local.tables_root}/${var.tables.tbl_aircraft_types}/"
      }
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
      comment = "Manufacturer name (generated in source via CASE expression)"
    }
    columns {
      name    = "cdc_operation"
      type    = "string"
      comment = "CDC operation type (I/U/D)"
    }
    columns {
      name    = "cdc_timestamp"
      type    = "timestamp"
      comment = "CDC capture timestamp"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (icao_code)"
    }
  }
}
