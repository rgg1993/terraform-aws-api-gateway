terraform {
  required_version = "> 0.14.0"
}

// Resource
resource "aws_route53_zone" "this" {
  lifecycle {
    prevent_destroy = true
  }
  name = var.name
  tags = var.tags
}