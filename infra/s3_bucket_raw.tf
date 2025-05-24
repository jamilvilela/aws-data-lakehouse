resource "aws_s3_bucket" "raw_bucket" {
  bucket = var.raw_bucket
  force_destroy = true        

  tags = {
    Name        = var.raw_bucket
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "raw_bucket_public_access_block" {
  bucket = aws_s3_bucket.raw_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "raw-bucket-config" {
  bucket = aws_s3_bucket.raw_bucket.id

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
