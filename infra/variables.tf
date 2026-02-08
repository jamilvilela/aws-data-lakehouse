
############################################
# IAM variables

variable "datalake_role_name" {
  type = string  
}

variable "datalake_policy_name" {
  type = string  
}

variable "user_lake_admin_name" {
  type    = string
}

############################################
# S3 bucket variables
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