output "id" {
  description = "Domain name id"
  value       = aws_apigatewayv2_domain_name.this.id
}

output "arn" {
  description = "Domain name arn"
  value       = aws_apigatewayv2_domain_name.this.arn
}