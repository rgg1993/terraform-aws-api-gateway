variable "description" {
  description = "The IAM policy description."
  type        = string
}

variable "name" {
  description = "The IAM policy name."
  type        = string
}

variable "policy" {
  description = "The IAM policy JSON."
  type        = string
}

variable "tags" {
  description = "The IAM role tags."
  type        = map(string)
}