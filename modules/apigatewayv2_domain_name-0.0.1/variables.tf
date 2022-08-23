variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "domain_name_configuration_endpoint_type" {
  description = "Domain name endpoint type"
  type        = string
  default     = "REGIONAL"
}

variable "domain_name_configuration_security_policy" {
  description = "Domain name security policy"
  type        = string
  default     = "TLS_1_2"
}

variable "acm_certificate_domain" {
  description = "Certificate domain"
  type        = string
}

variable "acm_certificate_types" {
  description = "Certificate type"
  type        = list(any)
}

variable "acm_certificate_most_recent" {
  description = "Get most recent certificate"
  default     = true
  type        = bool
}
