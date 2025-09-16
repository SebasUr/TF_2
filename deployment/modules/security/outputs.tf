output "sg_bastion_id" { value = aws_security_group.bastion.id }
output "sg_lb_id" { value = aws_security_group.lb.id }
output "sg_frontend_id" { value = aws_security_group.frontend.id }
output "sg_backend_id" { value = aws_security_group.backend.id }
