variable "tables" {
  description = "Glue tables for the data lake"
  type        = map(string)
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
