### Defaults

variable "region" {
  description = "Default AWS region."
  type        = string
}

variable "kms_key" {
  description = "KMS key"
  type        = string
}

variable "tags" {
  description = "Project tags"
  type        = map(any)
}

### Api gateway variables
variable "r53_zone_name" {
  description = "Name of the Route53 hosted zone"
}

variable "env_certificate_domain" {
  description = "Domain where the SSL certificate is issued fot the enviroment"
}

variable "environments" {
  description = "Environments"
  type        = map(any)
}

variable "services" {
  description = "Api services"
  type        = map(any)
}

variable "cloudwatch_log_groups" {
  description = "Cloudwatch log groups to be created"
  type        = map(any)
}

variable "stages" {
  description = "Api stages"
  type        = map(any)
}

variable "env_root_domain" {
  description = "Env root domain"
  type        = string
}

variable "apigateway_integration" {
  description = "Api gateway integration"
  type        = map(any)
}

variable "apigateway_authorizers" {
  description = "Api gateway authorizer"
  type        = map(any)
}

variable "apigateway_domain_name" {
  description = "Api gateway domain name"
  type        = map(any)
}

variable "iam_roles" {
  description = "IAM roles."
  type        = map(any)
}

variable "iam_policies" {
  description = "IAM policies."
  type        = map(any)
}

variable "iam_policy_attachments" {
  description = "IAM policy attachments."
  type        = map(any)
}

variable "waf_ip_sets" {
  description = "WAF ip sets"
  type        = map(any)
}

variable "managed_rules" {
  description = "AWS managed rules"
  type = map(any)
}

variable "s3_buckets" {
  description = "S3 buckets"
  type        = map(any)
}

variable "s3_bucket_logging" {
  description = "S3 bucket logging"
  type        = map(any)
}

variable "kinesis_firehose_delivery_streams" {
  description = "Kineses firehose delivery streams"
  type        = map(any)
}

variable "aws_wafv2_rule_group_allowlist_rule_name" {
  type        = string
  description = "Name for wafv2 rule group allowlist"
}

variable "visibility_config_allowlist_rule_metric_name" {
  type        = string
  description = "Name for wafv2 rule metric group allowlist"
}

variable "visibility_config_allowlist_metric_name" {
  type        = string
  description = "Name for wafv2 metric group allowlist"
}

variable "wafv2_web_acl_name" {
  type        = string
  description = "Name for wafv2 web acl"
}


### DNS variables
variable "public_route53_record_simple" {
  description = "The route53 records with different values for traffic.disney.go.com"
  type        = map(any)
}

variable "public_route53_record_latency" {
  description = "The route53 records with latency for traffic.disney.go.com."
  type        = map(any)
}