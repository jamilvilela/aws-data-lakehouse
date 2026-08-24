# Bronze: airlines reference (Delta Lake, CDC from flight_radar.airlines)
resource "aws_glue_catalog_table" "fr_airlines" {
  name          = var.tables.fr_airlines
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "${local.tables_root}/${var.tables.fr_airlines}/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library

      parameters = {
        "serialization.format" = "1"
        "path"                 = "${local.tables_root}/${var.tables.fr_airlines}/"
      }
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
      name    = "cod_unique"
      type    = "string"
      comment = "PK concatenation (icao_code)"
    }
  }
}
