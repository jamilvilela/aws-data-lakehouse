# Bronze: aircraft registry (Delta Lake, CDC from flight_radar.aircraft)
resource "aws_glue_catalog_table" "fr_aircraft" {
  name          = var.tables.fr_aircraft
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "${local.tables_root}/${var.tables.fr_aircraft}/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library

      parameters = {
        "serialization.format" = "1"
        "path"                 = "${local.tables_root}/${var.tables.fr_aircraft}/"
      }
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
      comment = "PK concatenation (icao24)"
    }
  }
}
