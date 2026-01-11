variable "control_account" {
  type        = string
  description = "AWS account ID for the Glue Catalog."
}

variable "datalake_role_arn" {
  type = string
}

variable "lake_admin_arn" {
  type = string  
}


variable "buckets" {
  description = "S3 buckets for the data lake"
  type = object({
    workspace = string
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
  type = object({
    etl_control  = string
    data_quality = string
  })
}


