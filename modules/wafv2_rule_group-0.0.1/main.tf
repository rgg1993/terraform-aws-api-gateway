
terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_wafv2_rule_group" "this" {
  name     = var.name
  scope    = var.scope
  capacity = var.capacity

  dynamic "rule" {
    rule = var.rule
  }

  dynamic "visibility_config" {
    visibility_config = var.visibility_config
  }

}