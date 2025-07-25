resource "aws_s3_bucket" "workspace_bucket" {
  bucket = var.buckets.workspace
  force_destroy = true        

  tags = merge(
    var.tags,
    {
      Name = var.buckets.workspace
    }
  )
}

resource "aws_s3_bucket_public_access_block" "workspace_bucket" {
  bucket = aws_s3_bucket.workspace_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.workspace_bucket.id

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

resource "aws_s3_bucket_server_side_encryption_configuration" "workspace_bucket" {
  bucket = aws_s3_bucket.workspace_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
