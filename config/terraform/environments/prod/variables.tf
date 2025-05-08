variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "restaurant-recommendation"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# KMS Variables
variable "kms_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number
  default     = 7
}

# DynamoDB Variables
variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  description = "The attribute to use as the hash (partition) key"
  type        = string
  default     = "id"
}

variable "dynamodb_attributes" {
  description = "List of nested attribute definitions"
  type = list(object({
    name = string
    type = string
  }))
  default = [
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
}

variable "dynamodb_global_secondary_indexes" {
  description = "Describe a GSI for the table"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = optional(number)
    write_capacity  = optional(number)
  }))
  default = [
    {
      name            = "StyleVegetarianIndex"
      hash_key        = "style"
      range_key       = "vegetarian"
      projection_type = "ALL"
    }
  ]
}

# Lambda Variables
variable "lambda_filename" {
  description = "Path to the Lambda function deployment package"
  type        = string
  default     = "../../lambda/function.zip"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "app.handler"
}

variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "python3.10"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "lambda_log_retention_days" {
  description = "Number of days to retain Lambda CloudWatch logs"
  type        = number
  default     = 30
}

variable "lambda_policy_statements" {
  description = "List of IAM policy statements for the Lambda role"
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = [
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
}

# API Gateway Variables
variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = null
}

variable "api_gateway_protocol_type" {
  description = "API Gateway protocol type"
  type        = string
  default     = "HTTP"
}

variable "api_gateway_stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = null
}

variable "api_gateway_auto_deploy" {
  description = "Whether to automatically deploy changes to the stage"
  type        = bool
  default     = true
}

variable "api_gateway_log_retention_days" {
  description = "Number of days to retain API Gateway CloudWatch logs"
  type        = number
  default     = 30
}

variable "api_gateway_log_format" {
  description = "Format for API Gateway access logs"
  type = object({
    requestId      = string
    ip            = string
    requestTime   = string
    httpMethod    = string
    routeKey      = string
    status        = string
    protocol      = string
    responseTime  = string
  })
  default = {
    requestId      = "$context.requestId"
    ip            = "$context.identity.sourceIp"
    requestTime   = "$context.requestTime"
    httpMethod    = "$context.httpMethod"
    routeKey      = "$context.routeKey"
    status        = "$context.status"
    protocol      = "$context.protocol"
    responseTime  = "$context.responseLatency"
  }
}

variable "api_gateway_routes" {
  description = "List of API Gateway routes"
  type = list(object({
    route_key = string
    target    = string
  }))
  default = [
    {
      route_key = "GET /recommendations"
      target    = "integrations/lambda"
    }
  ]
}

variable "api_gateway_integration_type" {
  description = "Type of API Gateway integration"
  type        = string
  default     = "AWS_PROXY"
}

variable "api_gateway_integration_method" {
  description = "HTTP method for the integration"
  type        = string
  default     = "POST"
}

variable "api_gateway_connection_type" {
  description = "Type of connection for the integration"
  type        = string
  default     = "INTERNET"
}

variable "api_gateway_integration_description" {
  description = "Description of the API Gateway integration"
  type        = string
  default     = "Lambda integration"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "restaurant-recommendation"
    ManagedBy   = "Terraform"
  }
} 