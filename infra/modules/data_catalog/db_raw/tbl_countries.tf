# ------------------------------------------------------------------------------
# tbl_countries — Countries reference table
# Source: DMS CDC from flight_radar.countries (Aurora PostgreSQL)
# Format: Delta Lake
# PK: id
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_countries" {
  name          = var.tables.tbl_countries
  database_name = var.databases.raw

  table_type = local.table_type

  parameters = local.delta_parameters

  partition_keys {
    name = local.delta_partition_key.name
    type = local.delta_partition_key.type
  }

  storage_descriptor {
    location      = "s3://${var.buckets.raw}/tables/tbl_countries/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      name                  = local.delta_ser_de.name
      serialization_library = local.delta_ser_de.serialization_library
    }

    columns {
      name    = "id"
      type    = "int"
      comment = "Country internal ID (PK)"
    }
    columns {
      name    = "code"
      type    = "string"
      comment = "ISO 2-letter country code"
    }
    columns {
      name    = "name"
      type    = "string"
      comment = "Country name"
    }
    columns {
      name    = "continent"
      type    = "string"
      comment = "Continent code"
    }
    columns {
      name    = "wikipedia_link"
      type    = "string"
      comment = "Wikipedia page URL"
    }
    columns {
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (id)"
    }
  }
}
