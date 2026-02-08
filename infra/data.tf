data "aws_caller_identity" "current" {} 

data "aws_iam_user" "lake_admin" {
  user_name = var.user_lake_admin_name
}