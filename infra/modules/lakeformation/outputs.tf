output "lakeformation_workflow_role_arn" {
  description = "ARN of the Lake Formation Workflow IAM Role"
  value       = aws_iam_role.lakeformation_workflow_role.arn
}

output "lf_workflow_permissions_policy_id" {
  description = "ID of the Lake Formation Workflow IAM Role Policy"
  value       = aws_iam_role_policy.lf_workflow_permissions.id
}

output "raw_datalake_location_arn" {
  description = "ARN of the Lake Formation resource for the raw bucket"
  value       = aws_lakeformation_resource.raw_datalake_location.arn
}

output "refined_datalake_location_arn" {
  description = "ARN of the Lake Formation resource for the refined bucket"
  value       = aws_lakeformation_resource.refined_datalake_location.arn
}

output "business_datalake_location_arn" {
  description = "ARN of the Lake Formation resource for the business bucket"
  value       = aws_lakeformation_resource.business_datalake_location.arn
}

output "datalake_admin_user_arn" {
  description = "ARN of the Data Lake admin user"
  value       = aws_iam_user.datalake_admin.arn
}

output "datalake_user1_arn" {
  description = "ARN of the Datalake User1 user"
  value       = aws_iam_user.datalake_user1.arn
}

