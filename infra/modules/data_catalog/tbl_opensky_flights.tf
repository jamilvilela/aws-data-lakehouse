resource "aws_glue_catalog_table" "tbl_opensky_flights" {
    name          = var.tables.tbl_opensky_flights
    database_name = var.databases.landing

    table_type = "EXTERNAL_TABLE"

    parameters = {
    classification = "parquet"
    compressionType = "snappy"
    }

    partition_keys {
        name = "event_date"
        type = "date"
    }

    storage_descriptor {
        location      = "s3://${var.buckets.landing}/opensky/flights/"
        input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
        output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

        ser_de_info {
        name                  = "parquet"
        serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
        }

        columns {
            name = "icao24"
            type = "string"
        }
        columns {
            name = "callsign"
            type = "string"
        }
        columns {
            name = "origin_country"
            type = "string"
        }
        columns {
            name = "latitude"
            type = "double"
        }
        columns {
            name = "longitude"
            type = "double"
        }
        columns {
            name = "altitude"
            type = "double"
        }
        columns {
            name = "velocity"
            type = "double"
        }
        columns {
            name = "heading"
            type = "double"
        }
        columns {
            name = "last_contact"
            type = "bigint"
        }
        columns {
            name = "event_time"
            type = "string"
        }
        columns {
            name = "location"
            type = "string"
        }
    }
}
