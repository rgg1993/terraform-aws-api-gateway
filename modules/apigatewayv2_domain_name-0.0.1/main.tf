terraform {
  required_version = "> 0.14.0"
}

// Data

data "aws_acm_certificate" "this" {
  domain      = var.acm_certificate_domain
  types       = var.acm_certificate_types
  most_recent = var.acm_certificate_most_recent
}

// Resources

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = var.domain_name
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.this.arn
    endpoint_type   = var.domain_name_configuration_endpoint_type
    security_policy = var.domain_name_configuration_security_policy
  }
}