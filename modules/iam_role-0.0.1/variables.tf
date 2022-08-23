variable "assume_role_policy" {
  description = "The IAM role assume role policy."
  type        = string
}

variable "description" {
  description = "The IAM role description."
  type        = string
}

variable "force_detach_policies" {
  description = "The IAM role option to force the policies to detach if deleted. Default is true."
  type        = bool
  default     = true
}

variable "name" {
  description = "The IAM role name."
  type        = string
}

variable "tags" {
  description = "The IAM role tags."
  type        = map(string)
}