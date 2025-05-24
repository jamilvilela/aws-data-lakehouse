output "datalake_role_arn" {
  value = aws_iam_role.datalake_role.arn
}

output "datalake_role_name" {
  value = aws_iam_role.datalake_role.name
}

output "workspace_bucket_arn" {
  value = aws_s3_bucket.workspace_bucket.arn
}

output "raw_bucket_arn" {
  value = aws_s3_bucket.raw_bucket.arn
}

output "refined_bucket_arn" {
  value = aws_s3_bucket.refined_bucket.arn
}

output "business_bucket_arn" {
  value = aws_s3_bucket.business_bucket.arn
}

