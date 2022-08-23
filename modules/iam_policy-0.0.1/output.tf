output "arn" {
  description = "The IAM policy ARN."
  value       = aws_iam_policy.this.arn
}

output "id" {
  description = "The IAM policy ID."
  value       = aws_iam_policy.this.id
}