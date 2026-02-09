data "aws_caller_identity" "current" {}

# Nota: lake_admin user não é mais necessário para Lake Formation settings.
# A função de administrador agora é assumida pela role datalake-admins-lf-role
# que é acessível pelos usuários do grupo datalake-admins.
#
# Comentado: data "aws_iam_user" "lake_admin" para possível uso futuro.
# data "aws_iam_user" "lake_admin" {
#   user_name = var.user_lake_admin_name
# }