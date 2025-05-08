locals {
  # Prepare policy statements with proper resources
  policy_statements = [
    for statement in var.policy_statements : {
      effect    = statement.effect
      actions   = statement.actions
      resources = length(statement.resources) > 0 ? statement.resources : (
        contains(statement.actions, "dynamodb:") ? [var.dynamodb_table_arn] :
        contains(statement.actions, "logs:") ? [
          aws_cloudwatch_log_group.lambda_logs.arn,
          "${aws_cloudwatch_log_group.lambda_logs.arn}:*"
        ] :
        contains(statement.actions, "kms:") ? [var.kms_key_arn] :
        []
      )
    }
  ]
} 