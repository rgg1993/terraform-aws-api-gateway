terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = var.api_id
  description = var.description
  lifecycle {
    create_before_destroy = true
  }
}