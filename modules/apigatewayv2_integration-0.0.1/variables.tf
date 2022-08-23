variable "description" {
  description = "Api gateway integration description"
  type        = string
}

variable "connection_id" {
  description = "Connection id"
  type        = string
}
variable "tls_config_server_name_to_verify" {
  description = "Api gateway integration tls config server name to verify"
  type        = string
}

variable "request_parameters" {
  description = "Api gateway integration request parameters"
  type        = map(any)
}

variable "api_id" {
  description = "Api id"
  type        = string

}

variable "integration_type" {
  description = "Integration type"
  type        = string
}

variable "connection_type" {
  description = "Connection type"
  type        = string
}

variable "integration_method" {
  description = "Integration method"
  type        = string

}

variable "integration_uri" {
  description = "Integration uri"
  type        = string
}