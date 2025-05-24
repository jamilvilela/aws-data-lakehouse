resource "aws_s3_bucket" "refined_bucket" {
  bucket = var.buckets.refined
  force_destroy = true        

  tags = merge(
    var.tags,
    {
      Name = var.buckets.refined
    }
  )
}


resource "aws_s3_bucket_public_access_block" "refined_bucket_public_access_block" {
  bucket = aws_s3_bucket.refined_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "refined-bucket-config" {
  bucket = aws_s3_bucket.refined_bucket.id

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
