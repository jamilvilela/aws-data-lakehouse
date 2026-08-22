# Data lake user - policies come from group membership
resource "aws_iam_user" "datalake_user1" {
  name = var.users.datalake_user1.name
}

resource "aws_iam_user_login_profile" "datalake_user1" {
  user                    = aws_iam_user.datalake_user1.name
  password_reset_required = true
}

# Adds the user to the datalake-users-internal group
resource "aws_iam_group_membership" "datalake_user1_membership" {
  name       = "datalake-user1-group-membership"
  users      = [aws_iam_user.datalake_user1.name]
  group      = aws_iam_group.datalake_users_internal.name
  depends_on = [aws_iam_group.datalake_users_internal]
}