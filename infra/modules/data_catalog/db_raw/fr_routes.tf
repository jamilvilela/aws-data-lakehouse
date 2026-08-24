# Bronze: route catalog (Delta Lake, CDC from flight_radar.routes)
resource "aws_glue_catalog_table" "fr_routes" {
  name          = var.tables.fr_routes
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "${local.tables_root}/${var.tables.fr_routes}/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library

      parameters = {
        "serialization.format" = "1"
        "path"                 = "${local.tables_root}/${var.tables.fr_routes}/"
      }
    }

    columns {
      name    = "id"
      type    = "bigint"
      comment = "Route ID (PK)"
    }
    columns {
      name    = "airline_iata"
      type    = "string"
      comment = "Airline IATA code"
    }
    columns {
      name    = "airline_id"
      type    = "int"
      comment = "Airline internal ID (FK)"
    }
    columns {
      name    = "src_airport"
      type    = "string"
      comment = "Source airport IATA code"
    }
    columns {
      name    = "src_airport_id"
      type    = "int"
      comment = "Source airport internal ID (FK)"
    }
    columns {
      name    = "dst_airport"
      type    = "string"
      comment = "Destination airport IATA code"
    }
    columns {
      name    = "dst_airport_id"
      type    = "int"
      comment = "Destination airport internal ID (FK)"
    }
    columns {
      name    = "codeshare"
      type    = "string"
      comment = "Codeshare indicator"
    }
    columns {
      name    = "stops"
      type    = "int"
      comment = "Number of stops"
    }
    columns {
      name    = "equipment"
      type    = "string"
      comment = "ICAO aircraft type codes"
    }
    columns {
      name    = "duration_minutes"
      type    = "int"
      comment = "Route duration in minutes"
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
      comment = "PK concatenation (id)"
    }
  }
}
