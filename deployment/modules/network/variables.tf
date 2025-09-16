variable "vpc_cidr" { type = string }
variable "enable_dns_support" {
  type    = bool
  default = true
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "public_subnets" {
  description = "Lista de objetos { cidr, az }"
  type        = list(object({ cidr = string, az = string }))
}
variable "private_subnets" {
  description = "Lista de objetos { cidr, az }"
  type        = list(object({ cidr = string, az = string }))
}
variable "create_nat_gateways" {
  type    = bool
  default = true
}
