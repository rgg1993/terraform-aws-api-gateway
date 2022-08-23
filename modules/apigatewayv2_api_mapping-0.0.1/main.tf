terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id          = var.api_id
  domain_name     = var.domain_name
  stage           = var.stage
  api_mapping_key = var.api_mapping_key
}