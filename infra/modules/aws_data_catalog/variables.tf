variable "control_account" {
  type        = string
  description = "AWS account ID for the Glue Catalog."
}

variable "datalake_role_name" {
  type        = string
  description = "Name of the Data Lake IAM role."
}
variable "datalake_role_arn" {
  type = string
}

variable "lake_admin_arn" {
  type = string  
}

# variable "control_table_name" {
#   type        = string
#   description = "Name of the control table in Glue Catalog."
# }

# variable "data_quality_table_name" {
#   type        = string
#   description = "Name of the data quality table in Glue Catalog."
# }

# variable "databases_raw" {
#   type        = string
#   description = "Name of the raw database in Glue Catalog." 
# }
# variable "databases_refined" {
#   type        = string
#   description = "Name of the refined database in Glue Catalog." 
# }

# variable "databases_business" {
#   type        = string
#   description = "Name of the business database in Glue Catalog."
# }


# variable "workspace_bucket" {
#   description = "Name of the workspace S3 bucket"
#   type        = string
# }

# variable "raw_bucket" {
#   description = "Name of the raw S3 bucket"
#   type        = string
# }

# variable "refined_bucket" {
#   description = "Name of the refined S3 bucket"
#   type        = string
# }

# variable "business_bucket" {
#   description = "Name of the business S3 bucket"
#   type        = string
# }


variable "buckets" {
  description = "S3 buckets for the data lake"
  type = object({
    workspace = string
    raw       = string
    refined   = string
    business  = string
  })
}

variable "databases" {
  description = "Glue databases for the data lake"
  type = object({
    raw      = string
    refined  = string
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


