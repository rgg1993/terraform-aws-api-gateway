variable "name" {
  description = "WAF ip set name"
  type        = string
}

variable "description" {
  description = "WAF ip set description"
  type        = string
}

variable "scope" {
  description = "WAF ip set scope"
  type        = string
  default     = "REGIONAL"
}

variable "ip_address_version" {
  description = "WAF ip set address version"
  type        = string
  default     = "IPV4"
}

variable "addresses" {
  description = "WAF ip set addresses"
  type        = list(any)
}

variable "tags" {
  description = "WAF ip set tags"
  type        = map(any)
}