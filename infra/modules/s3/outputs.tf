output "raw_bucket_arn" {
  value = aws_s3_bucket.raw_bucket.arn
}

output "refined_bucket_arn" {
  value = aws_s3_bucket.refined_bucket.arn
}

output "business_bucket_arn" {
  value = aws_s3_bucket.business_bucket.arn
}

output "workspace_bucket_arn" {
  value = aws_s3_bucket.workspace_bucket.arn
}