terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_iam_policy_attachment" "this" {
  lifecycle {
    prevent_destroy = true
  }

  groups     = var.groups
  policy_arn = var.policy_arn
  name       = var.name
  roles      = var.roles
  users      = var.users
}