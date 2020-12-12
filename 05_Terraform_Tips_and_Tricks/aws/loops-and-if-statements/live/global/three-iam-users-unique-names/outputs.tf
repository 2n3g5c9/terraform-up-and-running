output "neo_arn" {
  description = "The ARN for user Neo"
  value       = aws_iam_user.example[0].arn
}

output "all_arns" {
  description = "The ARNs for all users"
  value       = aws_iam_user.example[*].arn
}
