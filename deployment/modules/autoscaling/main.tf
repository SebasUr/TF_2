resource "aws_launch_template" "this" {
  name_prefix            = var.lt_name_prefix
  image_id               = var.launch_template_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg_web_id]
  key_name               = var.key_name

  # aws_launch_template.user_data expects base64-encoded content
  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = var.asg_name }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}
