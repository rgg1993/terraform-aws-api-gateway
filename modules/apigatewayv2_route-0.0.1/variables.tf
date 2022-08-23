variable "api_id" {
  description = "Api id"
  type        = string
}

variable "route_key" {
  description = "Api gateway route key"
  type        = string
}
variable "target" {
  description = "Api gateway route target"
  type        = string
}

variable "authorization_type" {
  description = "Api gateway authorization type"
  type        = string
}
variable "authorizer_id" {
  description = "Api gateway authorizer id"
  type        = string
}
