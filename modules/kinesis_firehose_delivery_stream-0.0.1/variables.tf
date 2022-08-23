variable "name" {
  description = "Firehose delivery stream name"
  type        = string
}

variable "destination" {
  description = "Firehose delivery stream destination"
  type        = string
  default     = "extended_s3"
}

variable "s3_configuration_role_arn" {
  description = "Arn role of the AWS credentials"
  type        = string
}

variable "s3_configuration_bucket_arn" {
  description = "Arn of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(any)
}