terraform {
  required_version = "> 0.14.0"

  backend "s3" {
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

// Data

data "aws_caller_identity" "current" {}

data "aws_lb" "ingress_alb" {
  for_each = var.environments
  name     = each.value["alb_name"]
}

data "aws_lb_listener" "alb_lnsr_443" {
  for_each          = var.environments
  load_balancer_arn = data.aws_lb.ingress_alb[each.value["environment"]].arn
  port              = 443
}

// Resources

### API

## Api gateway api
module "apigatewayv2_api" {
  source                       = "./modules/apigatewayv2_api-0.0.1"
  for_each                     = var.services
  name                         = each.value.name
  protocol_type                = each.value.protocol_type
  description                  = each.value.description
  disable_execute_api_endpoint = each.value.disable_execute_api_endpoint
  tags                         = merge({ Name = each.value.name }, var.tags)
}

## Api gateway vpc link
module "apigatewayv2_vpc_link" {
  source             = "./modules/apigatewayv2_vpc_link-0.0.1"
  for_each           = var.environments
  name               = each.key
  security_group_ids = data.aws_lb.ingress_alb[each.value["environment"]].security_groups
  subnet_ids         = data.aws_lb.ingress_alb[each.value["environment"]].subnets
  tags               = merge({ Name = each.key }, var.tags)
}

## Api gateway account
resource "aws_api_gateway_account" "account" {
  depends_on          = [module.iam_role]
  cloudwatch_role_arn = module.iam_role["apigateway-cloudwatch"].arn
}

## Api gateway default stages
module "apigatewayv2_stage" {
  source                                          = "./modules/apigatewayv2_stage-0.0.1"
  depends_on                                      = [module.cloudwatch_log_group]
  for_each                                        = var.services
  api_id                                          = module.apigatewayv2_api[each.key].id
  name                                            = var.stages["$default"].name
  auto_deploy                                     = var.stages["$default"].auto_deploy
  default_route_settings_detailed_metrics_enabled = var.stages["$default"].default_route_settings_detailed_metrics_enabled
  default_route_settings_logging_level            = var.stages["$default"].default_route_settings_logging_level
  default_route_settings_throttling_burst_limit   = var.stages["$default"].default_route_settings_throttling_burst_limit
  default_route_settings_throttling_rate_limit    = var.stages["$default"].default_route_settings_throttling_rate_limit
  access_log_settings_format                      = var.stages["$default"].access_log_settings_format
  access_log_settings_destination_arn             = module.cloudwatch_log_group["apigateway-cloudwatch-log-group"].arn
}

## Api gateway integration
#  we're using private integration type
module "apigatewayv2_integration" {
  source                           = "./modules/apigatewayv2_integration-0.0.1"
  depends_on                       = [module.apigatewayv2_api, module.apigatewayv2_vpc_link]
  for_each                         = var.services
  api_id                           = module.apigatewayv2_api[each.key].id
  description                      = each.value.apigateway_integration_description
  integration_uri                  = data.aws_lb_listener.alb_lnsr_443[each.value["environment"]].arn
  integration_type                 = var.apigateway_integration["http_int"].integration_type
  integration_method               = var.apigateway_integration["http_int"].integration_method
  connection_type                  = var.apigateway_integration["http_int"].connection_type
  connection_id                    = module.apigatewayv2_vpc_link[each.value.environment].id
  tls_config_server_name_to_verify = each.value.apigateway_integration_hostname
  request_parameters = {
    "overwrite:header.host" : each.value["apigateway_integration_hostname"]
    "overwrite:path" : each.value["internal_service_path"]
    "overwrite:header.client-ip" : "$request.header.X-Forwarded-For"
  }
}

# Api gateway authorizer
module "apigatewayv2_authorizer" {
  source                     = "./modules/apigatewayv2_authorizer-0.0.1"
  depends_on                 = [module.apigatewayv2_api]
  for_each                   = var.services
  name                       = each.value.authorizer_name
  api_id                     = module.apigatewayv2_api[each.key].id
  identity_sources           = var.apigateway_authorizers["authorizer"].identity_sources
  authorizer_type            = var.apigateway_authorizers["authorizer"].authorizer_type
  jwt_configuration_audience = var.apigateway_authorizers["authorizer"].jwt_configuration_audience
  jwt_configuration_issuer   = var.apigateway_authorizers["authorizer"].jwt_configuration_issuer
}

# Api gateway route
module "apigatewayv2_route" {
  source             = "./modules/apigatewayv2_route-0.0.1"
  depends_on         = [module.apigatewayv2_api, module.apigatewayv2_integration, module.apigatewayv2_authorizer]
  for_each           = var.services
  api_id             = module.apigatewayv2_api[each.key].id
  route_key          = each.value["api_route_key"]
  target             = "integrations/${module.apigatewayv2_integration[each.key].id}"
  authorization_type = var.apigateway_authorizers["authorizer"].authorizer_type
  authorizer_id      = module.apigatewayv2_authorizer[each.key].id
}

# Api gateway domain name
module "apigatewayv2_domain_name" {
  source                                    = "./modules/apigatewayv2_domain_name-0.0.1"
  acm_certificate_domain                    = var.apigateway_domain_name["your-apigateway-custom-domain-name"].acm_certificate_domain
  acm_certificate_most_recent               = var.apigateway_domain_name["your-apigateway-custom-domain-name"].acm_certificate_most_recent
  acm_certificate_types                     = var.apigateway_domain_name["your-apigateway-custom-domain-name"].acm_certificate_types
  domain_name                               = var.apigateway_domain_name["your-apigateway-custom-domain-name"].domain_name
  domain_name_configuration_endpoint_type   = var.apigateway_domain_name["your-apigateway-custom-domain-name"].domain_name_configuration_endpoint_type
  domain_name_configuration_security_policy = var.apigateway_domain_name["your-apigateway-custom-domain-name"].domain_name_configuration_security_policy
}

# Api gateway mapping
module "apigatewayv2_api_mapping" {
  source          = "./modules/apigatewayv2_api_mapping-0.0.1"
  depends_on      = [module.apigatewayv2_api, module.apigatewayv2_stage, module.apigatewayv2_domain_name]
  for_each        = var.services
  api_id          = module.apigatewayv2_api[each.key].id
  domain_name     = module.apigatewayv2_domain_name.id
  stage           = module.apigatewayv2_stage[each.key].id
  api_mapping_key = each.value["internal_service_name"]
}

# Api gateway deployment
module "apigatewayv2_deployment" {
  source      = "./modules/apigatewayv2_deployment-0.0.1"
  depends_on  = [module.apigatewayv2_integration, module.apigatewayv2_route]
  for_each    = var.services
  api_id      = module.apigatewayv2_api[each.key].id
  description = each.value.description
}

## Role for api gateway cloudwatch
module "iam_role" {
  source             = "./modules/iam_role-0.0.1"
  for_each           = var.iam_roles
  assume_role_policy = file(each.value.assume_role_policy_file_path)
  description        = each.value.description
  name               = each.value.name
  tags               = merge({ Name = each.value.name }, var.tags)
}

## Policies for api gateway cloudwatch role
module "iam_policy" {
  source      = "./modules/iam_policy-0.0.1"
  for_each    = var.iam_policies
  description = each.value.description
  name        = each.value.name
  policy      = file(each.value.policy_file_path)
  tags        = merge({ Name = each.value.name }, var.tags)
}

# Attach policies for api gateway cloudwatch role
module "iam_policy_attachment" {
  source     = "./modules/iam_policy_attachment-0.0.1"
  for_each   = var.iam_policy_attachments
  name       = each.value.policy_name
  policy_arn = module.iam_policy[each.key].arn
  roles      = each.value.roles
  users      = each.value.users
}

## Cloudwatch log group for api
module "cloudwatch_log_group" {
  source            = "./modules/cloudwatch_log_group-0.0.1"
  for_each          = var.cloudwatch_log_groups
  name              = each.value.name
  retention_in_days = each.value.retention_in_days
  tags              = merge({ Name = each.key }, var.tags)
}

### WAF
# Waf ip set
module "wafv2_ip_set" {
  source             = "./modules/wafv2_ip_set-0.0.1"
  for_each           = var.waf_ip_sets
  name               = each.value.name
  description        = each.value.description
  scope              = each.value.scope
  ip_address_version = each.value.ip_address_version
  addresses          = flatten(each.value.addresses)
  tags               = merge({ Name = each.key }, var.tags)
}

# Waf web acl
module "wafv2_web_acl" {
  source        = "./modules/wafv2_web_acl-0.0.1"
  depends_on    = [aws_wafv2_rule_group.allowlist_rule]
  name          = var.wafv2_web_acl_name
  scope         = "REGIONAL"
  managed_rules = var.managed_rules
  group_rules = [
    {
      excluded_rules : [],
      name : aws_wafv2_rule_group.allowlist_rule[0].name,
      arn : aws_wafv2_rule_group.allowlist_rule[0].arn,
      override_action : "none",
      priority : 1
    }
  ]
}

# Waf alb association
module "wafv2_web_acl_association" {
  source       = "./modules/wafv2_web_acl_association-0.0.1"
  depends_on   = [module.wafv2_web_acl]
  for_each     = var.environments
  resource_arn = data.aws_lb.ingress_alb[each.value["environment"]].arn
  web_acl_arn  = module.wafv2_web_acl.web_acl_id
}

/*
  NOTE: Since these rule groups are very customized and have way too many variablesit was decided not to modularized it.
*/

# Waf rule groups
resource "aws_wafv2_rule_group" "allowlist_rule" {
  depends_on = [module.wafv2_ip_set]
  name       = var.aws_wafv2_rule_group_allowlist_rule_name
  scope      = "REGIONAL"
  capacity   = 10

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {
      and_statement {
        statement {
          size_constraint_statement {
            field_to_match {
              single_header {
                name = "client-ip"
              }
            }
            comparison_operator = "GT"
            size                = 1
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = module.wafv2_ip_set["ip-set-waf-eks"].arn
                ip_set_forwarded_ip_config {
                  fallback_behavior = "NO_MATCH"
                  header_name       = "client-ip"
                  position          = "FIRST"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = var.visibility_config_allowlist_rule_metric_name
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.visibility_config_allowlist_metric_name
    sampled_requests_enabled   = true
  }
}


# Waf logging bucket

module "s3_bucket" {
  source      = "./modules/s3_bucket-0.0.4"
  for_each    = var.s3_buckets
  bucket_name = each.value.name
  tags        = var.tags
}

module "s3_bucket_logging" {
  source                = "./modules/s3_bucket_logging-0.0.1"
  depends_on            = [module.s3_bucket]
  for_each              = var.s3_bucket_logging
  s3_bucket             = each.value.bucket_name
  logging_target_bucket = each.value.logging_target_bucket
  logging_target_prefix = each.value.logging_target_prefix
}

module "s3_bucket_versioning" {
  source             = "./modules/s3_bucket_versioning-0.0.1"
  depends_on         = [module.s3_bucket]
  for_each           = var.s3_buckets
  s3_bucket          = each.value.name
  versioning_enabled = each.value.versioning_enabled
}

module "s3_bucket_acl" {
  source     = "./modules/s3_bucket_acl-0.0.1"
  depends_on = [module.s3_bucket]
  for_each   = var.s3_buckets
  s3_bucket  = each.value.name
  acl        = each.value.acl
}

// S3 Public access block
module "s3_bucket_public_access_block" {
  source                  = "./modules/s3_bucket_public_access_block-0.0.1"
  depends_on              = [module.s3_bucket]
  for_each                = var.s3_buckets
  s3_bucket               = each.value.name
  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  ignore_public_acls      = each.value.ignore_public_acls
  restrict_public_buckets = each.value.restrict_public_buckets
}

module "kinesis_firehose_delivery_stream" {
  source                      = "./modules/kinesis_firehose_delivery_stream-0.0.1"
  depends_on                  = [module.iam_role, module.s3_bucket]
  for_each                    = var.kinesis_firehose_delivery_streams
  name                        = each.value.name
  destination                 = each.value.destination
  s3_configuration_role_arn   = each.value.extended_s3_configuration_role_arn
  s3_configuration_bucket_arn = each.value.extended_s3_configuration_bucket_arn
  tags                        = var.tags
}

module "waf_web_acl_logging_configuration" {
  source                  = "./modules/wafv2_web_acl_logging_configuration-0.0.1"
  depends_on              = [module.kinesis_firehose_delivery_stream, module.wafv2_web_acl]
  log_destination_configs = [module.kinesis_firehose_delivery_stream["waf-eks-logs"].arn]
  resource_arn            = module.wafv2_web_acl.web_acl_id
}

### DNS
module "public_route53_record_simple" {
  source            = "./modules/route53_record-0.0.4"
  depends_on        = [module.apigatewayv2_api]
  for_each          = var.public_route53_record_simple
  zone_id           = each.value.zone_id
  name              = "${each.key}.${var.public_route53_zone_name}"
  type              = each.value.type
  route53_zone_name = each.value.route_53_zone_name
  records           = each.value.record_value
}

module "public_route53_record_latency" {
  source                        = "./modules/route53_record-0.0.4"
  depends_on                    = [module.apigatewayv2_api]
  for_each                      = var.public_route53_record_latency
  zone_id                       = each.value.zone_id
  alias                         = each.value.alias
  latency_routing_policy_region = each.value.latency_region
  name                          = "${each.value.name}.${var.public_route53_zone_name}"
  records                       = module.apigatewayv2_api[each.key].api_endpoint
  route53_zone_name             = each.value.route_53_zone_name
  set_identifier                = each.value.set_identifier
  type                          = each.value.type
}