# Data lake admin user - policies come from group membership
resource "aws_iam_user" "datalake_admin" {
  name = var.users.datalake_admin.name
}

resource "aws_iam_user_login_profile" "datalake_admin" {
  user                    = aws_iam_user.datalake_admin.name
  password_reset_required = true
}

# Adds the admin user to the datalake-admins group
resource "aws_iam_group_membership" "datalake_admin_membership" {
  name = "datalake-admin-group-membership"
  users = [
    aws_iam_user.datalake_admin.name,
    var.lake_admin_name
  ]
  group      = aws_iam_group.datalake_admins.name
  depends_on = [aws_iam_group.datalake_admins]
}