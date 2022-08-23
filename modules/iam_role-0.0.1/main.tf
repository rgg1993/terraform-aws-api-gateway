terraform {
  required_version = "> 0.14.0"
}

// Data
// Resources

resource "aws_iam_role" "this" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      # Bespin issues seen where it looses federation and sometimes regains it.
      # It's suspected this is happening due to it fixing the assume role.
      assume_role_policy
    ]
  }

  assume_role_policy    = var.assume_role_policy
  description           = var.description
  force_detach_policies = var.force_detach_policies
  name                  = var.name

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

