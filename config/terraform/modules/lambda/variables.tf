variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "filename" {
  description = "Path to the Lambda function deployment package"
  type        = string
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
}

variable "runtime" {
  description = "Lambda function runtime"
  type        = string
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for CloudWatch logs encryption"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "policy_statements" {
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
      resources = []  # Will be set in the module
    },
    {
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = []  # Will be set in the module
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
      resources = []  # Will be set in the module
    }
  ]
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
} 