terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources
resource "aws_apigatewayv2_integration" "this" {
  api_id             = var.api_id
  description        = var.description
  integration_type   = var.integration_type
  integration_uri    = var.integration_uri
  integration_method = var.integration_method
  connection_type    = var.connection_type
  connection_id      = var.connection_id

  tls_config {
    server_name_to_verify = var.tls_config_server_name_to_verify
  }

  request_parameters = var.request_parameters

}