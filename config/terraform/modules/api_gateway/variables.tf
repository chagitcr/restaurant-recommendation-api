variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for CloudWatch logs encryption"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = null
}

variable "protocol_type" {
  description = "API Gateway protocol type"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "WEBSOCKET"], var.protocol_type)
    error_message = "Protocol type must be either HTTP or WEBSOCKET."
  }
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = null
}

variable "auto_deploy" {
  description = "Whether to automatically deploy changes to the stage"
  type        = bool
  default     = true
}

variable "log_format" {
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

variable "routes" {
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

variable "integration_type" {
  description = "Type of API Gateway integration"
  type        = string
  default     = "AWS_PROXY"
  validation {
    condition     = contains(["AWS", "AWS_PROXY", "HTTP", "HTTP_PROXY", "MOCK"], var.integration_type)
    error_message = "Integration type must be one of: AWS, AWS_PROXY, HTTP, HTTP_PROXY, MOCK."
  }
}

variable "integration_method" {
  description = "HTTP method for the integration"
  type        = string
  default     = "POST"
  validation {
    condition     = contains(["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "ANY"], var.integration_method)
    error_message = "Integration method must be a valid HTTP method."
  }
}

variable "connection_type" {
  description = "Type of connection for the integration"
  type        = string
  default     = "INTERNET"
  validation {
    condition     = contains(["INTERNET", "VPC_LINK"], var.connection_type)
    error_message = "Connection type must be either INTERNET or VPC_LINK."
  }
}

variable "integration_description" {
  description = "Description of the API Gateway integration"
  type        = string
  default     = "Lambda integration"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
} 