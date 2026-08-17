variable "control_account" {
  type = string
}

variable "lake_admin_name" {
  type        = string
  description = "Name of the lake admin user to add to the admins group (legacy)"
  default     = ""
}

variable "datalake_role_arn" {
  type        = string
  description = "ARN of the datalake analytics IAM role"
}

variable "datalake_policy_arn" {
  type        = string
  description = "ARN of the datalake analytics IAM policy"
}

variable "workspace_bucket_arn" {
  description = "ARN of the workspace S3 bucket"
  type        = string
}

variable "raw_bucket_arn" {
  description = "ARN of the raw S3 bucket"
  type        = string
}

variable "trusted_bucket_arn" {
  description = "ARN of the trusted S3 bucket"
  type        = string
}

variable "business_bucket_arn" {
  description = "ARN of the business S3 bucket"
  type        = string
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
  type = object({
    etl_control  = string
    data_quality = string
  })
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