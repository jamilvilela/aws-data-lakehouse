resource "aws_glue_catalog_database" "db_raw" {
  name = var.databases.raw
  location_uri = "s3://${var.buckets.raw}"
} 

resource "aws_glue_catalog_database" "db_refined" {
  name = var.databases.refined
  location_uri = "s3://${var.buckets.refined}"
} 

resource "aws_glue_catalog_database" "db_business" {
  name = var.databases.business
  location_uri = "s3://${var.buckets.business}"
}
