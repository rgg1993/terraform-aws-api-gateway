terraform {
  required_version = "> 0.14.0"
}

// Data

data "aws_route53_zone" "this" {
  name = var.route53_zone_name
}

// Resources

resource "aws_route53_record" "this" {
  lifecycle {
    prevent_destroy = true
  }

  dynamic "alias" {
    for_each = var.alias == null ? [] : [true]
    content {
      evaluate_target_health = alias.value.evaluate_target_health
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.latency_routing_policy_region == null ? [] : [true]

    content {
      region = var.latency_routing_policy_region
    }
  }

  name           = var.name
  records        = length(var.alias) == 0 ? var.records : null
  set_identifier = var.set_identifier
  ttl            = length(var.alias) == 0 ? var.ttl : null
  type           = var.type


  dynamic "weighted_routing_policy" {
    for_each = var.weighted_routing_policy_weight == null ? [] : [true]

    content {
      weight = var.weighted_routing_policy_weight
    }
  }

  zone_id = data.aws_route53_zone.this.zone_id

}