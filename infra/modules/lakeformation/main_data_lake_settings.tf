# Lake Formation data lake admins
resource "aws_lakeformation_data_lake_settings" "this" {
  admins = [
    aws_iam_role.datalake_admins_lf_role.arn
  ]
}