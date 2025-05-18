resource "aws_glue_catalog_database" "db_raw" {
  name = var.raw_db_name
  location_uri = "s3://${var.raw_bucket}"

  depends_on = [ aws_s3_bucket.raw_bucket ]
} 

resource "aws_glue_catalog_database" "db_refined" {
  name = var.refined_db_name
  location_uri = "s3://${var.refined_bucket}"

  depends_on = [ aws_s3_bucket.refined_bucket ]
} 

resource "aws_glue_catalog_database" "db_business" {
  name = var.business_db_name
  location_uri = "s3://${var.business_bucket}"

  depends_on = [ aws_s3_bucket.business_bucket ]
}
