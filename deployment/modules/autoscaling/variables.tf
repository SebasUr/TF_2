variable "private_subnet_ids" { type = list(string) }
variable "launch_template_ami" { type = string }
variable "instance_type" { type = string }
variable "sg_web_id" { type = string }
variable "key_name" { type = string }
variable "target_group_arn" { type = string }
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }

variable "user_data" {
  type        = string
  description = "Cloud-init/User data script (plain text). Will be base64-encoded."
  default     = ""
}

variable "asg_name" {
  type        = string
  description = "Name for the Auto Scaling Group"
}

variable "lt_name_prefix" {
  type        = string
  description = "Launch template name prefix"
  default     = "lt-"
}
