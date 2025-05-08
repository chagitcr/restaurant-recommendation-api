aws_region = "us-west-2"
project_name = "restaurant-recommendation"
environment = "prod"

# KMS Variables
kms_deletion_window_in_days = 7

# DynamoDB Variables
dynamodb_billing_mode = "PAY_PER_REQUEST"
dynamodb_hash_key = "id"
dynamodb_attributes = [
  {
    name = "id"
    type = "S"
  },
  {
    name = "style"
    type = "S"
  },
  {
    name = "vegetarian"
    type = "S"
  }
]
dynamodb_global_secondary_indexes = [
  {
    name            = "StyleVegetarianIndex"
    hash_key        = "style"
    range_key       = "vegetarian"
    projection_type = "ALL"
  }
]

# Lambda Variables
lambda_filename = "../../../../src/lambda/function.zip"
lambda_handler = "app.lambda_handler"
lambda_runtime = "python3.10"
lambda_timeout = 30
lambda_memory_size = 128
lambda_log_retention_days = 30
lambda_policy_statements = [
  {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = []
  },
  {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = []
  },
  {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = []
  }
]

# API Gateway Variables
api_gateway_name = "restaurant-recommendation-api"
api_gateway_protocol_type = "HTTP"
api_gateway_stage_name = "dev"
api_gateway_auto_deploy = true
api_gateway_log_retention_days = 30
api_gateway_log_format = {
  requestId      = "$context.requestId"
  ip            = "$context.identity.sourceIp"
  requestTime   = "$context.requestTime"
  httpMethod    = "$context.httpMethod"
  routeKey      = "$context.routeKey"
  status        = "$context.status"
  protocol      = "$context.protocol"
  responseTime  = "$context.responseLatency"
}
api_gateway_routes = [
  {
    route_key = "GET /recommendations"
    target    = "integrations/lambda"
  }
]
api_gateway_integration_type = "AWS_PROXY"
api_gateway_integration_method = "POST"
api_gateway_connection_type = "INTERNET"
api_gateway_integration_description = "Lambda integration"

# Common Tags
tags = {
  Environment = "dev"
  Project     = "restaurant-recommendation"
  ManagedBy   = "Terraform"
} 