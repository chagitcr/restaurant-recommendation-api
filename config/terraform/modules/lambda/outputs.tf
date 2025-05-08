output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.restaurant_recommendation.function_name
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.restaurant_recommendation.arn
}

output "invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = aws_lambda_function.restaurant_recommendation.invoke_arn
}

output "role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda_role.arn
} 