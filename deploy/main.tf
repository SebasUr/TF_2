terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}


variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "session_token" {
  description = "AWS session token"
  type        = string
  sensitive   = true
}

provider "aws" {
    region     = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
    token      = var.session_token
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "tb_books"
}

resource "aws_dynamodb_table" "books" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

output "table_name" {
  value       = aws_dynamodb_table.books.name
  description = "DynamoDB table name"
}

output "table_arn" {
  value       = aws_dynamodb_table.books.arn
  description = "DynamoDB table ARN"
}
