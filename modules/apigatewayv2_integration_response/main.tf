terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources
resource "aws_apigatewayv2_integration_response" "this" {
  api_id                   = var.api_id
  integration_id           = var.integration_id
  integration_response_key = var.integration_response_key
}