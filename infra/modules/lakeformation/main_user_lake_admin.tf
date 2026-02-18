################################################################################
# Usuário Data Lake Admin
# 
# Este usuário será adicionado ao grupo datalake-admins.
# As policies vêm do grupo; não incluir policies diretas aqui.
# 
# Alternativa: você pode usar um usuário existente do diretório corporativo
# (SSO via Cognito/SAML) em vez de criar um usuário local IAM.
################################################################################

resource "aws_iam_user" "datalake_admin" {
  name = var.users.datalake_admin.name
}

resource "aws_iam_user_login_profile" "datalake_admin" {
  user                    = aws_iam_user.datalake_admin.name
  password_reset_required = true
}

# Adicionar o usuário ao grupo datalake-admins
resource "aws_iam_group_membership" "datalake_admin_membership" {
  name       = "datalake-admin-group-membership"
  users      = [
    aws_iam_user.datalake_admin.name, 
    var.lake_admin_name
  ]
  group      = aws_iam_group.datalake_admins.name
  depends_on = [aws_iam_group.datalake_admins]
}