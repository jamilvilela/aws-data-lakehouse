resource "aws_lakeformation_resource" "raw_datalake_location" {
  arn = var.raw_bucket_arn
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"
  use_service_linked_role = true
}

resource "aws_lakeformation_resource" "trusted_datalake_location" {
  arn = var.trusted_bucket_arn
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"
  use_service_linked_role = true
}

resource "aws_lakeformation_resource" "business_datalake_location" {
  arn = var.business_bucket_arn
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"
  use_service_linked_role = true
}