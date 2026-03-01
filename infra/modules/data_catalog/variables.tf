variable "control_account" {
  type        = string
  description = "AWS account ID for the Glue Catalog."
}

variable "datalake_role_arn" {
  type = string
  description = "ARN of the datalake service role (Glue, EMR, etc)"
}

# Variáveis para as 3 roles LF de acesso por grupo
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

# Mantendo para compatibilidade (comentado, será descontinuado)
variable "lake_admin_arn" {
  type        = string
  description = "ARN of the lake-admin user (deprecated; use datalake_admins_principal_arn instead)"
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
    landing  = string
    raw      = string
    trusted  = string
    business = string
  })
}

variable "tables" {
  description = "Glue tables for the data lake"
  type = map(string)  
}


