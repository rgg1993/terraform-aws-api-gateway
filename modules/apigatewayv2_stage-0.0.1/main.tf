terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_apigatewayv2_stage" "this" {
  api_id      = var.api_id
  name        = var.name
  auto_deploy = var.auto_deploy

  default_route_settings {
    detailed_metrics_enabled = var.default_route_settings_detailed_metrics_enabled
    logging_level            = var.default_route_settings_logging_level
    throttling_burst_limit   = var.default_route_settings_throttling_burst_limit
    throttling_rate_limit    = var.default_route_settings_throttling_rate_limit
  }
  access_log_settings {
    destination_arn = var.access_log_settings_destination_arn
    format          = jsonencode(var.access_log_settings_format)
  }
}