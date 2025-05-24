resource "aws_s3_bucket" "business_bucket" {
  bucket = var.business_bucket
  force_destroy = true        

  tags = {
    Name        = var.business_bucket
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "business_bucket_public_access_block" {
  bucket = aws_s3_bucket.business_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "business-bucket-config" {
  bucket = aws_s3_bucket.business_bucket.id

  rule {
    id = "lifecycle"
    status = "Enabled"

    filter {
      prefix = "tmp/"
    }

    transition {
      days          = 60
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
