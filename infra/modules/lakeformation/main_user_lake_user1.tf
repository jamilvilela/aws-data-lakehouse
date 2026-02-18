################################################################################
# Usuário Data Lake User1
# 
# Este usuário será adicionado ao grupo datalake-users-internal.
# As policies vêm do grupo; não incluir policies diretas aqui.
################################################################################

resource "aws_iam_user" "datalake_user1" {
  name = var.users.datalake_user1.name
}

resource "aws_iam_user_login_profile" "datalake_user1" {
  user                    = aws_iam_user.datalake_user1.name
  password_reset_required = true
}

# Adicionar o usuário ao grupo datalake-users-internal
# As policies vêm do grupo; não adicionar policies diretas ao usuário
resource "aws_iam_group_membership" "datalake_user1_membership" {
  name       = "datalake-user1-group-membership"
  users      = [aws_iam_user.datalake_user1.name]
  group      = aws_iam_group.datalake_users_internal.name
  depends_on = [aws_iam_group.datalake_users_internal]
}