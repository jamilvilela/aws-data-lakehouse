# Define quem são os administradores do Lake Formation
resource "aws_lakeformation_data_lake_settings" "this" {
  admins = [
    var.lake_admin_arn
    # "arn:aws:iam::331504768406:role/alguma-role-admin",
  ]
}