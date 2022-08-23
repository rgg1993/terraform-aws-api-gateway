terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_apigatewayv2_api" "this" {
  name                         = var.name
  protocol_type                = var.protocol_type
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  tags                         = var.tags
}