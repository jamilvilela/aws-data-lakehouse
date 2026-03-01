resource "aws_glue_catalog_database" "db_landing" {
  name = var.databases.landing
  location_uri = "s3://${var.buckets.landing}"
} 

resource "aws_glue_catalog_database" "db_raw" {
  name = var.databases.raw
  location_uri = "s3://${var.buckets.raw}"
} 

resource "aws_glue_catalog_database" "db_trusted" {
  name = var.databases.trusted
  location_uri = "s3://${var.buckets.trusted}"
} 

resource "aws_glue_catalog_database" "db_business" {
  name = var.databases.business
  location_uri = "s3://${var.buckets.business}"
}
