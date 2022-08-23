resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  tags              = var.tags
  retention_in_days = var.retention_in_days
}