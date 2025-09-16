resource "aws_lb" "this" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_groups    = [var.sg_lb_id]
  subnets            = var.public_subnet_ids
  internal           = false
}

# Frontend target group (serves static site on port 80)
resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path     = var.frontend_health_check_path
    protocol = "HTTP"
    matcher  = "200-399"
    interval = var.health_check_interval
  }
}

# Backend target group (API)
resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = var.backend_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path     = var.backend_health_check_path
    protocol = "HTTP"
    matcher  = "200-399"
    interval = var.health_check_interval
  }
}

# Listener HTTP 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

# Rule: route /api/* to backend TG
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
  condition {
    path_pattern {
      values = [var.api_path]
    }
  }
}
