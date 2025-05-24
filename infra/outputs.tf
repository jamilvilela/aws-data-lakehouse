output "raw_bucket_arn" {
  value = module.s3.raw_bucket_arn
}

output "refined_bucket_arn" {
  value = module.s3.refined_bucket_arn
}

output "business_bucket_arn" {
  value = module.s3.business_bucket_arn
}

output "datalake_role_arn" {
  description = "ARN of the main Data Lake role"
  value       = module.iam.datalake_role_arn
}

output "lakeformation_workflow_role_arn" {
  description = "ARN of the Lake Formation Workflow role"
  value       = module.lakeformation.lakeformation_workflow_role_arn
}

output "datalake_admin_user_arn" {
  description = "ARN of the Data Lake admin user"
  value       = module.lakeformation.datalake_admin_user_arn
}

output "datalake_user1_arn" {
  description = "ARN of the Datalake User1 user"
  value       = module.lakeformation.datalake_user1_arn
}
