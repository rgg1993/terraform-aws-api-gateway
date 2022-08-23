variable "api_id" {
  description = "Api id"
}

variable "name" {
  description = "Api gateway stage name"
  type        = string
}


variable "auto_deploy" {
  description = "Enable autodeploy"
  type = bool
}

variable "default_route_settings_detailed_metrics_enabled" { 
  description = "Enable detailed metrics"
  type = bool
}

variable "default_route_settings_logging_level" {
  description = "Default route settings logging level"
  type = string
}

variable "default_route_settings_throttling_burst_limit" {
  description = "Default route settings throttling burst limit"
  type = string
}

variable "default_route_settings_throttling_rate_limit" {
  description = "Default route settings throttling rate limit"
  type = string
}

variable "access_log_settings_destination_arn" {
  description = "Access log settings destination arn"
  type = string
}

variable "access_log_settings_format" {
  description = "Access log settings format"
  type = string
}
