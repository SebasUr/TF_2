variable "vpc_id" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }

variable "backend_port" {
  type    = number
  default = 5001
}
