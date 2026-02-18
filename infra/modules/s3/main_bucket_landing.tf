resource "aws_s3_bucket" "landing_bucket" {
  bucket = var.buckets.landing
  force_destroy = true        

  tags = merge(
    var.tags,
    {
      Name = var.buckets.landing
    }
  )
}

resource "aws_s3_bucket_public_access_block" "landing_bucket_public_access_block" {
  bucket = aws_s3_bucket.landing_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "landing-bucket-config" {
  bucket = aws_s3_bucket.landing_bucket.id

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
