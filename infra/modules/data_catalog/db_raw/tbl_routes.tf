# ------------------------------------------------------------------------------
# tbl_routes — Route catalog between airports
# Source: DMS CDC from flight_radar.routes (Aurora PostgreSQL)
# Format: Delta Lake
# PK: id
# ------------------------------------------------------------------------------
resource "aws_glue_catalog_table" "tbl_routes" {
  name          = var.tables.tbl_routes
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
    location      = "s3://${var.buckets.raw}/tables/tbl_routes/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "DeltaLakeSerDe"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
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
      name    = "cod_unico"
      type    = "string"
      comment = "PK concatenation (id)"
    }
  }
}
