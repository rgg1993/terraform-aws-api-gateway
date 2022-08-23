variable "name" {
  description = "VPC Link name"
  type        = string
}

variable "security_group_ids" {
  description = "Security group ids"
  type        = list(any)
}

variable "subnet_ids" {
  description = "Subnet ids"
  type        = list(any)
}

variable "tags" {
  description = "VPC Link tags"
  type        = map(any)
}