variable "aws_access_key_id" {
    type        = string
    description = "AWS Access Key ID (temporary)"
    sensitive   = true
}

variable "aws_secret_access_key" {
    type        = string
    description = "AWS Secret Access Key (temporary)"
    sensitive   = true
}

variable "aws_session_token" {
    type        = string
    description = "AWS Session Token (temporary)"
    sensitive   = true
}

provider "aws" {
    region = "us-east-1"

    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
    token      = var.aws_session_token
}

resource "aws_s3_bucket" "frontend_bucket" {
    bucket = "my-web-frontend-bucket-sauriber2"
}

resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
    bucket                  = aws_s3_bucket.frontend_bucket.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend_bucket" {
    bucket = aws_s3_bucket.frontend_bucket.id

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }
}

resource "aws_s3_bucket_policy" "frontend_bucket" {
    bucket = aws_s3_bucket.frontend_bucket.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{         
            Sid       = "PublicReadGetObject",
            Effect    = "Allow",
            Principal = "*",
            Action    = "s3:GetObject",
            Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
        }]
    })
}

resource "aws_s3_object" "frontend_files" {
    for_each = fileset("${path.module}/../frontend2/dist", "**")

    bucket = aws_s3_bucket.frontend_bucket.id
    key = each.value
    source = "${path.module}/../frontend2/dist/${each.value}"
    etag = filemd5("${path.module}/../frontend2/dist/${each.value}")

    content_type = lookup({
        html = "text/html",
        css  = "text/css",
        js   = "application/javascript",
        png  = "image/png",
        jpg  = "image/jpeg",
        svg  = "image/svg+xml",
        json = "application/json"
    }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

