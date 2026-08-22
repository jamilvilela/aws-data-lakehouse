# DATA_LOCATION_ACCESS for the service role (Glue/EMR/Athena)

resource "aws_lakeformation_permissions" "raw_location_datalake_role" {
  principal   = var.datalake_role_arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.raw_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.raw_datalake_location]
}

# DATA_LOCATION_ACCESS for the Glue job role (flight radar pipeline)

resource "aws_lakeformation_permissions" "raw_location_job_role" {
  principal   = var.datalake_job_role_arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.raw_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.raw_datalake_location]
}

resource "aws_lakeformation_permissions" "trusted_location_datalake_role" {
  principal   = var.datalake_role_arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.trusted_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.trusted_datalake_location]
}

resource "aws_lakeformation_permissions" "business_location_datalake_role" {
  principal   = var.datalake_role_arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.business_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.business_datalake_location]
}

# DATA_LOCATION_ACCESS for the LF admin role

resource "aws_lakeformation_permissions" "raw_location_admins" {
  principal   = aws_iam_role.datalake_admins_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.raw_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.raw_datalake_location]
}

resource "aws_lakeformation_permissions" "trusted_location_admins" {
  principal   = aws_iam_role.datalake_admins_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.trusted_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.trusted_datalake_location]
}

resource "aws_lakeformation_permissions" "business_location_admins" {
  principal   = aws_iam_role.datalake_admins_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.business_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.business_datalake_location]
}

# DATA_LOCATION_ACCESS for the internal users LF role

resource "aws_lakeformation_permissions" "raw_location_internal_users" {
  principal   = aws_iam_role.datalake_users_internal_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.raw_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.raw_datalake_location]
}

resource "aws_lakeformation_permissions" "trusted_location_internal_users" {
  principal   = aws_iam_role.datalake_users_internal_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.trusted_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.trusted_datalake_location]
}

resource "aws_lakeformation_permissions" "business_location_internal_users" {
  principal   = aws_iam_role.datalake_users_internal_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.business_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.business_datalake_location]
}

# DATA_LOCATION_ACCESS for the external users LF role

resource "aws_lakeformation_permissions" "business_location_external_users" {
  principal   = aws_iam_role.datalake_users_external_lf_role.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = var.business_bucket_arn
  }

  depends_on = [aws_lakeformation_resource.business_datalake_location]
}