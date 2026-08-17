variable "control_account" {
  type        = string
  description = "AWS account ID for the Glue Catalog."
}

variable "datalake_role_arn" {
  type        = string
  description = "ARN of the datalake service role (Glue, EMR, etc)"
}

variable "datalake_admins_principal_arn" {
  type        = string
  description = "ARN of the datalake-admins-lf-role (used as LF principal)"
}

variable "datalake_users_internal_principal_arn" {
  type        = string
  description = "ARN of the datalake-users-internal-lf-role (used as LF principal)"
}

variable "datalake_users_external_principal_arn" {
  type        = string
  description = "ARN of the datalake-users-external-lf-role (used as LF principal)"
}

variable "lake_admin_arn" {
  type        = string
  description = "ARN of the lake-admin user (deprecated)"
  default     = ""
}

variable "buckets" {
  description = "S3 buckets for the data lake"
  type = object({
    workspace = string
    landing   = string
    raw       = string
    trusted   = string
    business  = string
  })
}

variable "databases" {
  description = "Glue databases for the data lake"
  type = object({
    raw      = string
    trusted  = string
    business = string
  })
}

variable "tables" {
  description = "Glue tables for the data lake"
  type        = map(string)
}


