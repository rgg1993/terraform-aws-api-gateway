terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = var.resource_arn
  web_acl_arn  = var.web_acl_arn
}