variable "api_id" {
  description = "Api id"
  type        = string
}

variable "authorizer_type" {
  description = "Authorizer type for api"
  default     = "JWT"
  type        = string
}

variable "name" {
  description = "Name of the authorizer"
  type        = string
}

variable "jwt_configuration_audience" {
  description = "JWT configuration audience"
  type        = list(any)
}

variable "jwt_configuration_issuer" {
  description = "JWT configuration issuer"
  type        = string
}

variable "identity_sources" {
  description = "identity_sources"
  type        = list(any)
}