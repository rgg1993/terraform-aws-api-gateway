variable "api_id" {
  description = "Api id"
}

variable "name" {
  description = "Api gateway stage name"
  type        = string
}


variable "auto_deploy" {

}

variable "default_route_settings_detailed_metrics_enabled" {}
variable "default_route_settings_logging_level" {}
variable "default_route_settings_throttling_burst_limit" {}
variable "default_route_settings_throttling_rate_limit" {}
variable "access_log_settings_destination_arn" {}
variable "access_log_settings_format" {}
