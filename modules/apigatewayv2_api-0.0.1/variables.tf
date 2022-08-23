variable "name" {
  description = "Api name"
  type        = string
}

variable "protocol_type" {
  description = "Protocol type supported"
  type        = string
}

variable "description" {
  description = "Api description"
  type        = string
}

variable "disable_execute_api_endpoint" {
  description = "Disable_execute_api_endpoint"
  type        = bool
}

variable "tags" {
  description = "Tags"
  type        = map(any)
}