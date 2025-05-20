output "raw_bucket_arn" {
  value = aws_s3_bucket.raw_bucket.arn
}

output "refined_bucket_arn" {
  value = aws_s3_bucket.refined_bucket.arn
}

output "business_bucket_arn" {
  value = aws_s3_bucket.business_bucket.arn
}

output "datalake_role_arn" {
  description = "ARN da role principal do Data Lake"
  value       = aws_iam_role.datalake_role.arn
}

output "lakeformation_workflow_role_arn" {
  description = "ARN da role do Lake Formation Workflow"
  value       = aws_iam_role.lakeformation_workflow_role.arn
}

output "datalake_admin_user_arn" {
  description = "ARN do usuário admin do Data Lake"
  value       = aws_iam_user.datalake_admin.arn
}

output "datalake_user1_arn" {
  description = "ARN do usuário Datalake User1"
  value       = aws_iam_user.datalake_user1.arn
}