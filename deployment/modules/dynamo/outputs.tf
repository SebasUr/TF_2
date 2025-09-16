output "table_name" {
  value       = aws_dynamodb_table.dydb.name
  description = "DynamoDB table name"
}