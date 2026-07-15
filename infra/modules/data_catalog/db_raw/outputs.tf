output "tables" {
  description = "Map of table resource names to their Glue catalog names"
  value = {
    tbl_aircraft           = aws_glue_catalog_table.tbl_aircraft.name
    tbl_airports           = aws_glue_catalog_table.tbl_airports.name
    tbl_airlines           = aws_glue_catalog_table.tbl_airlines.name
    tbl_flights            = aws_glue_catalog_table.tbl_flights.name
    tbl_aircraft_positions = aws_glue_catalog_table.tbl_aircraft_positions.name
    tbl_countries          = aws_glue_catalog_table.tbl_countries.name
    tbl_aircraft_types     = aws_glue_catalog_table.tbl_aircraft_types.name
    tbl_routes             = aws_glue_catalog_table.tbl_routes.name
    etl_control            = aws_glue_catalog_table.etl_control.name
    data_quality           = aws_glue_catalog_table.data_quality_metrics.name
  }
}
