output "datalake_role_arn" {
  description = "ARN of the main Data Lake role"
  value       = aws_iam_role.datalake_role.arn
}

output "datalake_policy_name" {
  description = "Name of the Data Lake policy"
  value       = aws_iam_policy.datalake_policy.name
}