resource "aws_glue_catalog_table" "dataquality_metrics" {
  depends_on = [ aws_glue_catalog_database.db_raw ]
  name          = var.tabela_data_quality
  database_name = var.raw_db_name
  catalog_id    = var.control_account
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    classification = "parquet"
  }
  partition_keys {
    name = "dt_referencia"
    type = "date"
  }
  storage_descriptor {
    location      = "${var.raw_bucket}/tables/${var.tabela_data_quality}"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = var.tabela_data_quality
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }
    columns {
      name    = "database"
      type    = "string"
      comment = "Nome da base de dados avaliada"
    }
    columns {
      name    = "ts_processamento"
      type    = "timestamp"
      comment = "Data e hora de processamento"
    }
    columns {
      name    = "st_metrica"
      type    = "string"
      comment = "Metrica avaliadas"
    }
    columns {
      name    = "st_motivo_falha"
      type    = "string"
      comment = "Razão da falha da avaliação"
    }
    columns {
      name    = "st_status"
      type    = "string"
      comment = "Status da avaliação"
    }
    columns {
      name    = "st_particao"
      type    = "string"
      comment = "Identificação da partição avaliada da tabela"
    }
    columns {
      name    = "st_regra"
      type    = "string"
      comment = "Regra de avaliação aplicada"
    }
    columns {
      name    = "st_tabela"
      type    = "string"
      comment = "Nome da tabela avaliada"
    }
    columns {
      name    = "st_tecnologia"
      type    = "string"
      comment = "Nome da tecnologia da base de dados avaliada"
    }
  }
}
