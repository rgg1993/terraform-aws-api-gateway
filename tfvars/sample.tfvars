## Default

region          = "Your aws region, eg: us-east-1"
kms_key         = "Your kms key"

#### API GATEWAY VARS

r53_zone_name                                = "Your route53 hosted zone name"
env_root_domain                              = "Your root domain"
env_certificate_domain                       = "Your certificate domain"
aws_wafv2_rule_group_allowlist_rule_name     = "Your aws waf rule group allowlist name"
visibility_config_allowlist_rule_metric_name = "Your rule metric name"
visibility_config_allowlist_metric_name      = "Your metric name"
wafv2_web_acl_name                           = "Your waf acl name"

tags = {
  contact    = "Your team contact"
}

### API
## Api gateway vpc link
environments = {
  test = {
    environment = "Your environmente name, such as dev, uat, etc"
    alb_name    = "Your alb name that's going to receive the redirected requests"
  }
}

## Api gateway api
services = {
  "your-service-name" = {
    environment                        = "Your environment name"
    name                               = "Your service name"
    api_route_key                      = "Your api route key"
    internal_service_name              = "Your internal service name"
    internal_service_path              = "$request.path"
    protocol_type                      = "HTTP"
    disable_execute_api_endpoint       = true
    description                        = "Your apigateway endpoint description"
    apigateway_integration_description = "Your apigateway integration description"
    apigateway_integration_hostname    = "Your integration hostname"
    authorizer_name                    = "Your authorizer name"
  }
}

## Cloudwatch log group for api
cloudwatch_log_groups = {
  apigateway-cloudwatch-log-group = {
    retention_in_days = 7
    name              = "Your cloudwatch log group name"
  }
}

## Api gateway default stages
stages = {
  "$default" = {
    name                                            = "$default"
    auto_deploy                                     = "true"
    default_route_settings_detailed_metrics_enabled = true
    default_route_settings_logging_level            = "INFO"
    default_route_settings_throttling_burst_limit   = "5000"
    default_route_settings_throttling_rate_limit    = "10000"
    access_log_settings_format = {
      "requestId" : "$context.requestId",
      "ip" : "$context.identity.sourceIp",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "routeKey" : "$context.routeKey",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength"
    }
  }
}

## Api gateway integration
#  we're using private integration type
apigateway_integration = {
  http_int = {
    integration_method = "ANY"
    integration_type   = "HTTP_PROXY"
    connection_type    = "VPC_LINK"
  }
}

# Api gateway authorizer
apigateway_authorizers = {
 authorizer = {
    authorizer_type            = "JWT"
    identity_sources           = ["$request.header.Authorization"]
    name                       = "Your authorizer name"
    jwt_configuration_audience = ["Your authorizer audiences"]
    jwt_configuration_issuer   = "Your jwt configuration issuer"
  }
}

apigateway_domain_name = {
  "your-apigateway-custom-domain-name" = {
    acm_certificate_domain                    = "Your acm certificate domain"
    acm_certificate_types                     = ["IMPORTED"]
    acm_certificate_most_recent               = true
    domain_name                               = "Your apigateway domain name"
    domain_name_configuration_endpoint_type   = "REGIONAL"
    domain_name_configuration_security_policy = "TLS_1_2"
  }
}

## IAM roles
iam_roles = {
  apigateway-cloudwatch = {
    name                         = "Your apigateway cloudwatch role name"
    description                  = "The IAM role for api gateway cloudwatch."
    assume_role_policy_file_path = "The path to your policy file"
  },
  waf-eks-firehose = {
    name                         = "Your waf eks firehose role name"
    description                  = "Waf eks iam role"
    assume_role_policy_file_path = "The path to your policy file"
  }
}

## IAM policies
iam_policies = {
  apigateway-cloudwatch = {
    name             = "Your apigateway cloudwatch policy name"
    description      = "The primary IAM policy for IAM role for api gateway cloudwatch."
    policy_file_path = "The path to your policy file"
  },
  waf-eks-firehose = {
    name             = "Your waf eks firehose policy name"
    description      = "The primary IAM policy for IAM role for waf eks."
    policy_file_path = "The path to your policy file"
  }
}

iam_policy_attachments = {
  integration-apigateway-cloudwatch = {
    policy_name = "Your apigateway cloudwatch policy name"
    roles       = ["Your apigateway cloudwatch role name"]
    users       = []
  },
  waf-eks-firehose = {
    policy_name = "Your waf eks firehose policy name"
    roles       = ["Your waf eks firehose role name"]
    users       = []
  }
}

waf_ip_sets = {
  "ip-set-waf-eks" = {
    name               = "Your waf ip set name"
    description        = "Ip set waf eks"
    scope              = "REGIONAL"
    ip_address_version = "IPV4"
    addresses = ["Your ip addresses"]
  }
}

managed_rules = [
  {
    name            = "AWSManagedRulesCommonRuleSet",
    priority        = 10
    override_action = "none"
    excluded_rules  = []
  },
  {
    name            = "AWSManagedRulesAmazonIpReputationList",
    priority        = 20
    override_action = "none"
    excluded_rules  = []
  },
  {
    name            = "AWSManagedRulesKnownBadInputsRuleSet",
    priority        = 30
    override_action = "none"
    excluded_rules  = []
  },
  {
    name            = "AWSManagedRulesSQLiRuleSet",
    priority        = 40
    override_action = "none"
    excluded_rules  = []
  },
  {
    name            = "AWSManagedRulesLinuxRuleSet",
    priority        = 50
    override_action = "none"
    excluded_rules  = []
  },
  {
    name            = "AWSManagedRulesUnixRuleSet",
    priority        = 60
    override_action = "none"
    excluded_rules  = []
  }
]


s3_buckets = {
  waf-eks-logs = {
    name                    = "Your waf eks logs bucket name"
    acl                     = "private"
    versioning_enabled      = "Suspended"
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

s3_bucket_logging = {
  waf-eks-logs = {
    bucket_name           = "Your waf eks logging bucket name"
    logging_target_bucket = "Your waf eks logs bucket name"
    logging_target_prefix = "Your target prefix"
  }
}

kinesis_firehose_delivery_streams = {
  waf-eks-logs = {
    name                                 = "Your logs, must begin with aws-waf"
    destination                          = "s3"
    arn                                  = "Youre firehose delivery stream arn"
    extended_s3_configuration_role_arn   = "Your waf eks role arn"
    extended_s3_configuration_bucket_arn = "Your waf eks logs bucket arn"
  }
}


### DNS record

public_route53_record_latency = {
  "your-service-name" = {
    name              = "Your latency record name"
    type              = "CNAME"
    zone_id           = "Your hosted zone id"
    latency_region    = "Your working region"
    route53_zone_name = "Your route53 zone name"
    set_identifier    = "Your set identifier"
    alias             = {}
  }
}

public_route53_record_simple = {
  "your-record-name" = {
    type              = "CNAME"
    zone_id           = "Your hosted zone id"
    route53_zone_name = "Your route53 zone name"
    record_value      = ["Your alb endpoint"]
  }
}