variable "alias" {
  default     = {}
  description = "An alias block. If this is populated, TTL and records will be nulled out."
  type        = map(any)
}

variable "latency_routing_policy_region" {
  default     = null
  description = "Region for the latency policy"
  type        = string
}

variable "name" {
  description = "The route53 record name."
  type        = string
}

variable "records" {
  description = "A string list of records"
  type        = any
}

variable "route53_zone_name" {
  description = "The route53 record route53 zone name."
  type        = string
}

variable "set_identifier" {
  default     = null
  description = "Unique identifier. Required if using failover, geolocation, latency, or weighted routing policies."
  type        = string
}

variable "ttl" {
  default     = 300
  description = "The route53 record TTL."
  type        = number
}

variable "type" {
  description = "The route53 record type."
  type        = string
}

variable "weighted_routing_policy_weight" {
  default     = null
  description = "Weight for weighted policy"
  type        = string
}