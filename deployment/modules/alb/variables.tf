variable "public_subnet_ids" { type = list(string) }
variable "sg_lb_id" { type = string }
variable "vpc_id" { type = string }

# Frontend health check path
variable "frontend_health_check_path" {
  type    = string
  default = "/"
}
# Backend health check path
variable "backend_health_check_path" {
  type    = string
  default = "/api/health"
}
variable "backend_port" {
  type    = number
  default = 5001
}
variable "api_path" {
  type    = string
  default = "/api/*"
}
variable "health_check_interval" {
  type    = number
  default = 300
}
