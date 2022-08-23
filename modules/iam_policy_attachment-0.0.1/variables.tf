variable "groups" {
  description = "The IAM policy attachment groups."
  type        = list(string)
  default     = null
}

variable "policy_arn" {
  description = "The IAM policy attachment policy arn."
  type        = string
}

variable "name" {
  description = "The IAM policy attachment name."
  type        = string
}

variable "roles" {
  description = "The IAM policy attachment roles."
  type        = list(string)
}

variable "users" {
  description = "The IAM policy attachment users."
  type        = list(string)
  default     = null
}