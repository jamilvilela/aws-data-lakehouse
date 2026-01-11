output "landing_bucket_arn" {
  value = aws_s3_bucket.landing_bucket.arn
}

output "raw_bucket_arn" {
  value = aws_s3_bucket.raw_bucket.arn
}

output "trusted_bucket_arn" {
  value = aws_s3_bucket.trusted_bucket.arn
}

output "business_bucket_arn" {
  value = aws_s3_bucket.business_bucket.arn
}

output "workspace_bucket_arn" {
  value = aws_s3_bucket.workspace_bucket.arn
}