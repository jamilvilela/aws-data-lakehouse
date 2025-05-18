resource "aws_glue_catalog_table" "tb_controle_execucao_etl" {
  depends_on = [ aws_glue_catalog_database.db_raw ]
  name          = var.tabela_controle  
  database_name = var.raw_db_name
  catalog_id    = var.control_account
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    classification = "parquet"
  }

  partition_keys {
    name = "dt_referencia"
    type = "date"
    comment = "Data de referência da execução"
  }

  storage_descriptor {
    location      = "${var.raw_bucket}/tables/${var.tabela_controle}"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = var.tabela_controle
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }
    
    columns {
      name = "nm_tabela_destino"
      type = "string"
      comment = "Nome da tabela de destino"
    }
    columns {
      name    = "ts_inicio_execucao"
      type    = "timestamp"
      comment = "Data-Hora de início da execução"
    }
    columns {
      name    = "ts_termino_execucao"
      type    = "timestamp"
      comment = "Data-Hora de fim da execução"
    }
    columns {
      name    = "ds_particao_destino"
      type    = "string"
      comment = "Partição da tabela de destino"
    }
    columns {
      name    = "tx_origens"
      type    = "array<struct<nm_tabela_origem:string,ds_particao_origem:string>>"
      comment = "Dados das tabelas de origem"
    }
  }
}
