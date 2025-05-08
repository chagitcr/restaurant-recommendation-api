output "api_endpoint" {
  description = "The API Gateway endpoint URL"
  value       = "${aws_apigatewayv2_api.restaurant_api.api_endpoint}/${aws_apigatewayv2_stage.restaurant_api_stage.name}/recommendations"
}

output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.restaurant_api.id
}

output "execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.restaurant_api.execution_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.api_logs.name
} 