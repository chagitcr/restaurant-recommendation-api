resource "aws_apigatewayv2_api" "restaurant_api" {
  name          = var.api_name != null ? var.api_name : "${var.project_name}-api"
  protocol_type = var.protocol_type

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-api"
      Environment = var.environment
    }
  )
}

resource "aws_apigatewayv2_stage" "restaurant_api_stage" {
  api_id = aws_apigatewayv2_api.restaurant_api.id
  name   = var.stage_name != null ? var.stage_name : var.environment
  auto_deploy = var.auto_deploy

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode(var.log_format)
  }
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-api-logs"
      Environment = var.environment
    }
  )
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.restaurant_api.id
  integration_type = var.integration_type

  connection_type    = var.connection_type
  description        = var.integration_description
  integration_method = var.integration_method
  integration_uri    = var.lambda_invoke_arn
}

resource "aws_apigatewayv2_route" "routes" {
  for_each = { for route in var.routes : route.route_key => route }

  api_id    = aws_apigatewayv2_api.restaurant_api.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.restaurant_api.execution_arn}/*/*"
} 