variable "resource_arn" {
  description = "Resource arn to associate to waf"
  type        = string
}

variable "web_acl_arn" {
  description = "Waf web acl arn"
  type        = string
}