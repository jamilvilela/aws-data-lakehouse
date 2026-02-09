# Define quem são os administradores do Lake Formation
# 
# Recomendação: usar role em vez de user para melhor governança.
# A role datalake-admins-lf-role é assumida por usuários do grupo datalake-admins.
resource "aws_lakeformation_data_lake_settings" "this" {
  admins = [
    aws_iam_role.datalake_admins_lf_role.arn
    # Alternativa (comentado): usar user direto
    # var.lake_admin_arn
  ]
}