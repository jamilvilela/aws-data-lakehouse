variable "datalake_role_name" {
  type        = string
  description = "Name of the main data lake analytics IAM role"
}

variable "datalake_policy_name" {
  type        = string
  description = "Name of the main data lake IAM policy"
}

variable "datalake_job_role_name" {
  type        = string
  description = "Name of the Glue job role that writes to the raw layer (flight radar pipeline). The full ARN is assembled in locals using the account ID."
}

variable "user_lake_admin_name" {
  type        = string
  description = "Name of the lake admin user added to the admins group (legacy)"
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

variable "users" {
  description = "User credentials for the data lake"
  type = object({
    datalake_admin = object({
      name = string
    })
    datalake_user1 = object({
      name = string
    })
  })
}