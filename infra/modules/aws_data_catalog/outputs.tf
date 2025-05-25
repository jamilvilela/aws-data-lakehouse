# Glue Catalog module outputs

output "aws_glue_catalog_database_raw_name" {
  description = "Name of the Glue Catalog Raw database"
  value       = aws_glue_catalog_database.db_raw.name
}
output "aws_glue_catalog_database_refined_name" {
  description = "Name of the Glue Catalog Refined database"
  value       = aws_glue_catalog_database.db_refined.name
}
output "aws_glue_catalog_database_business_name" {
  description = "Name of the Glue Catalog Business database"
  value       = aws_glue_catalog_database.db_business.name
}

output "aws_glue_catalog_table_dataquality_metrics_name" {
  description = "Name of the data quality metrics table"
  value       = aws_glue_catalog_table.dataquality_metrics.name  
}