resource "aws_dynamodb_table" "restaurants" {
  name           = "${var.project_name}-${var.environment}"
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      read_capacity      = global_secondary_index.value.read_capacity
      write_capacity     = global_secondary_index.value.write_capacity
    }
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-dynamodb"
      Environment = var.environment
    }
  )
} 