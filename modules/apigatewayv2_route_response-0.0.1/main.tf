terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_apigatewayv2_route_response" "this" {
  api_id             = var.api_id
  route_id           = var.route_id
  route_response_key = var.route_response_key
}