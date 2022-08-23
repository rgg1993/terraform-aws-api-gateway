terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_iam_policy" "this" {
  lifecycle {
    prevent_destroy = true
  }

  description = var.description
  name        = var.name
  policy      = var.policy

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

