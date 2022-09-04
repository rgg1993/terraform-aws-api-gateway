variable "name" {
  description = "The route53 zone name."
  type        = string
}

variable "tags" {
  description = "The route53 zone tags."
  type        = map(string)
}