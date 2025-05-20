variable "control_account" {
  type = string
}

############################################
# IAM user variables
variable "datalake_admin_name" {
  type        = string
  description = "IAM user name to be created for this blog tutorial."
  default     = "DatalakeAdmin1"
}

variable "datalake_admin_password" {
  type        = string
  description = "IAM user console password for this blog tutorial."
}

variable "datalake_user1_name" {
  type        = string
  description = "IAM user name to be created for this blog tutorial."
  default     = "DatalakeUser1"
}

variable "datalake_user1_password" {
  type        = string
  description = "IAM user console password for this blog tutorial."
}

variable "lake_admin_arn" {
  type = string  
}

variable "datalake_role_arn" {
  type = string
}

variable "datalake_role_name" {
  type = string  
}

variable "datalake_policy_name" {
  type = string  
}

############################################
# S3 bucket variables
variable "workspace_bucket" {
  type = string  
}

variable "raw_bucket" {
  type = string
}

variable "refined_bucket" {
  type = string
}

variable "business_bucket" {
  type = string
}

############################################
# Glue Catalog variables
variable "raw_db_name" {
  type = string
}

variable "refined_db_name" {
  type = string
}

variable "business_db_name" {
  type = string
}

variable "tabela_controle" {
  type = string
}

variable "tabela_data_quality" {
  type = string
}