output "kms_key_arn" {
  description = "The ARN of the KMS key used for CloudWatch logs encryption"
  value       = aws_kms_key.cloudwatch_logs.arn
}
 
output "kms_key_alias" {
  description = "The alias of the KMS key"
  value       = aws_kms_alias.cloudwatch_logs.name
} 