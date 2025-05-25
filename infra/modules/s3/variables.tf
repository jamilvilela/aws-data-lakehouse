############################################
variable "buckets" {
  description = "S3 buckets for the data lake"
  type = object({
    workspace = string
    raw       = string
    refined   = string
    business  = string
  })
}

variable "tags" {
  description = "Tags to apply to all S3 buckets"
  type        = map(string)
  default     = {
    Environment = "dev"
  }
}

