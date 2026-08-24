output "tables" {
  description = "Map of table resource names to their Glue catalog names"
  value = {
    fr_aircraft           = aws_glue_catalog_table.fr_aircraft.name
    fr_airports           = aws_glue_catalog_table.fr_airports.name
    fr_airlines           = aws_glue_catalog_table.fr_airlines.name
    fr_flights            = aws_glue_catalog_table.fr_flights.name
    fr_aircraft_positions = aws_glue_catalog_table.fr_aircraft_positions.name
    fr_countries          = aws_glue_catalog_table.fr_countries.name
    fr_aircraft_types     = aws_glue_catalog_table.fr_aircraft_types.name
    fr_routes             = aws_glue_catalog_table.fr_routes.name
    etl_control            = aws_glue_catalog_table.etl_control.name
    data_quality           = aws_glue_catalog_table.data_quality_metrics.name
    rejected_records       = aws_glue_catalog_table.rejected_records.name
  }
}
