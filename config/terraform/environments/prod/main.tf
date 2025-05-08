terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

module "kms" {
  source = "../../modules/kms"

  project_name           = var.project_name
  environment           = var.environment
  deletion_window_in_days = var.kms_deletion_window_in_days
  tags                  = var.tags
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
  billing_mode = var.dynamodb_billing_mode
  hash_key     = var.dynamodb_hash_key
  attributes   = var.dynamodb_attributes
  global_secondary_indexes = var.dynamodb_global_secondary_indexes
  tags         = var.tags
}

module "lambda" {
  source = "../../modules/lambda"

  project_name         = var.project_name
  environment         = var.environment
  filename            = var.lambda_filename
  handler             = var.lambda_handler
  runtime             = var.lambda_runtime
  timeout             = var.lambda_timeout
  memory_size         = var.lambda_memory_size
  dynamodb_table_name = module.dynamodb.table_name
  dynamodb_table_arn  = module.dynamodb.table_arn
  kms_key_arn         = module.kms.kms_key_arn
  log_retention_days  = var.lambda_log_retention_days
  policy_statements   = var.lambda_policy_statements
  tags                = var.tags
}

module "api_gateway" {
  source = "../../modules/api_gateway"

  project_name           = var.project_name
  environment           = var.environment
  api_name              = var.api_gateway_name
  protocol_type         = var.api_gateway_protocol_type
  stage_name            = var.api_gateway_stage_name
  auto_deploy           = var.api_gateway_auto_deploy
  log_retention_days    = var.api_gateway_log_retention_days
  kms_key_arn           = module.kms.kms_key_arn
  lambda_invoke_arn     = module.lambda.invoke_arn
  lambda_function_name  = module.lambda.function_name
  log_format           = var.api_gateway_log_format
  routes               = var.api_gateway_routes
  integration_type     = var.api_gateway_integration_type
  integration_method   = var.api_gateway_integration_method
  connection_type      = var.api_gateway_connection_type
  integration_description = var.api_gateway_integration_description
  tags                 = var.tags
} 