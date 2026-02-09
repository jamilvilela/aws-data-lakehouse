# Define quem são os administradores do Lake Formation
# Esses administradores terão permissões para gerenciar o Lake Formation, 
# incluindo a capacidade de conceder permissões a outros usuários e grupos.

resource "aws_lakeformation_data_lake_settings" "this" {
  admins = [
    aws_iam_role.datalake_admins_lf_role.arn
  ]
}