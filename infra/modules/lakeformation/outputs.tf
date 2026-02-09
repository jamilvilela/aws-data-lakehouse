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

output "trusted_datalake_location_arn" {
  description = "ARN of the Lake Formation resource for the trusted bucket"
  value       = aws_lakeformation_resource.trusted_datalake_location.arn
}

output "business_datalake_location_arn" {
  description = "ARN of the Lake Formation resource for the business bucket"
  value       = aws_lakeformation_resource.business_datalake_location.arn
}

output "datalake_admin_arn" {
  description = "ARN of the Data Lake admin user"
  value       = aws_iam_user.datalake_admin.arn
}

output "datalake_user1_arn" {
  description = "ARN of the Datalake User1 user"
  value       = aws_iam_user.datalake_user1.arn
}

# ==============================================================================
# Outputs para os grupos e roles do novo modelo
# ==============================================================================

output "datalake_admins_group_arn" {
  description = "ARN of the datalake-admins IAM group"
  value       = aws_iam_group.datalake_admins.arn
}

output "datalake_admins_group_name" {
  description = "Name of the datalake-admins IAM group"
  value       = aws_iam_group.datalake_admins.name
}

output "datalake_users_internal_group_arn" {
  description = "ARN of the datalake-users-internal IAM group"
  value       = aws_iam_group.datalake_users_internal.arn
}

output "datalake_users_internal_group_name" {
  description = "Name of the datalake-users-internal IAM group"
  value       = aws_iam_group.datalake_users_internal.name
}

output "datalake_users_external_group_arn" {
  description = "ARN of the datalake-users-external IAM group"
  value       = aws_iam_group.datalake_users_external.arn
}

output "datalake_users_external_group_name" {
  description = "Name of the datalake-users-external IAM group"
  value       = aws_iam_group.datalake_users_external.name
}

output "datalake_admins_lf_role_arn" {
  description = "ARN of the datalake-admins-lf-role (for Lake Formation permissions)"
  value       = aws_iam_role.datalake_admins_lf_role.arn
}

output "datalake_admins_lf_role_name" {
  description = "Name of the datalake-admins-lf-role"
  value       = aws_iam_role.datalake_admins_lf_role.name
}

output "datalake_users_internal_lf_role_arn" {
  description = "ARN of the datalake-users-internal-lf-role (for Lake Formation permissions)"
  value       = aws_iam_role.datalake_users_internal_lf_role.arn
}

output "datalake_users_internal_lf_role_name" {
  description = "Name of the datalake-users-internal-lf-role"
  value       = aws_iam_role.datalake_users_internal_lf_role.name
}

output "datalake_users_external_lf_role_arn" {
  description = "ARN of the datalake-users-external-lf-role (for Lake Formation permissions)"
  value       = aws_iam_role.datalake_users_external_lf_role.arn
}

output "datalake_users_external_lf_role_name" {
  description = "Name of the datalake-users-external-lf-role"
  value       = aws_iam_role.datalake_users_external_lf_role.name
}

