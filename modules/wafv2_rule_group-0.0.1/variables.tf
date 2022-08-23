variable "name" {
  description = "WAF rule group name"
  type        = string
}

variable "scope" {
  description = "WAF rule group scope"
  type        = string
}

variable "capacity" {
  description = "WAF rule group capacity"
  type        = number
}

variable "rule" {
  description = "WAF rule"
  type        = map(any)
}

variable "visibility_config" {
  description = "WAF rule group visibility config"
  type        = map(any)
}