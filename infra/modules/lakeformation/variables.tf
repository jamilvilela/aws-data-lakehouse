variable "control_account" {
  type = string
}

############################################
# IAM variables
variable "lake_admin_arn" {
  type        = string
  description = "ARN of the lake-admin user (opcional se usar role de admin)"
  default     = ""
}

variable "datalake_role_arn" {
  type = string
}

variable "datalake_policy_name" {
  type = string  
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

############################################
# Glue Catalog variables
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

##############################################
# User credentials for the data lake
variable "users" {
  description = "User credentials for the data lake"
  type = object({
    datalake_admin     = object({
      name     = string
    })
    datalake_user1     = object({
      name     = string
    })
  })
}