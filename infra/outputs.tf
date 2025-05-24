output "datalake_role_arn" {
  value = aws_iam_role.datalake_role.arn
}

output "workspace_bucket_arn" {
  value = aws_s3_bucket.workspace_bucket.arn
}