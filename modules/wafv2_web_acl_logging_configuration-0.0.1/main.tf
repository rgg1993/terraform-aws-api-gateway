terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = var.log_destination_configs
  resource_arn            = var.resource_arn
}