output "api_endpoint" {
  description = "The API Gateway endpoint URL"
  value       = module.api_gateway.api_endpoint
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda.function_name
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = module.api_gateway.log_group_name
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for CloudWatch logs encryption"
  value       = module.kms.kms_key_arn
}

output "kms_key_alias" {
  description = "The alias of the KMS key"
  value       = module.kms.kms_key_alias
} 