variable "name" {
  description = "Cloudwatch log group name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(any)
}

variable "retention_in_days" {
  description = "Logs retention in days"
  type        = number
}