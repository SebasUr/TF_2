variable "region" {
  type    = string
  default = "us-east-1"
}

# AWS Credentials for Backend (temporary, not committed)
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

variable "key_name" {
  type    = string
  default = "hi"
}

variable "vpc_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

variable "public_subnets" {
  type = list(object({ cidr = string, az = string }))
  default = [
    { cidr = "172.16.1.0/24", az = "us-east-1a" },
    { cidr = "172.16.4.0/24", az = "us-east-1b" }
  ]
}
variable "private_subnets" {
  type = list(object({ cidr = string, az = string }))
  default = [
    { cidr = "172.16.2.0/24", az = "us-east-1a" },
    { cidr = "172.16.3.0/24", az = "us-east-1a" },
    { cidr = "172.16.5.0/24", az = "us-east-1b" },
    { cidr = "172.16.6.0/24", az = "us-east-1b" }
  ]
}
variable "create_nat_gateways" {
  type    = bool
  default = true
}

variable "bastion_ami" {
  type    = string
  default = "ami-020cba7c55df1f615"
}
variable "web_ami" {
  type    = string
  default = "ami-020cba7c55df1f615"
}

variable "instance_type_bastion" {
  type    = string
  default = "t2.micro"
}
variable "web_instance_type" {
  type    = string
  default = "t2.small"
}

variable "web_min" {
  type    = number
  default = 2
}
variable "web_max" {
  type    = number
  default = 2
}
variable "web_desired" {
  type    = number
  default = 2
}

variable "alb_health_check_path" {
  type    = string
  default = "/"
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "tb_books"
}

# Git repository URL to clone on instances (must contain docker-compose.yml)
variable "repo_url" {
  type        = string
  description = "Git repo URL"
  default     = "https://github.com/SebasUr/TF_2"
}

// Removed per-user overrides; always use local scripts
# variable "backend_user_data" {
#   type        = string
#   description = "Cloud-init/User data script to bootstrap instances"
#   default     = ""
# }
# variable "frontend_user_data" {
#   type        = string
#   description = "Cloud-init/User data script to bootstrap instances"
#   default     = ""
# }