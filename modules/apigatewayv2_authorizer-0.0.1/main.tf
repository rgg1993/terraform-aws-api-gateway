terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_apigatewayv2_authorizer" "this" {
  api_id           = var.api_id
  authorizer_type  = var.authorizer_type
  identity_sources = var.identity_sources
  name             = var.name

  jwt_configuration {
    audience = var.jwt_configuration_audience
    issuer   = var.jwt_configuration_issuer
  }
}