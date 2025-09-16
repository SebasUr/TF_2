output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }
output "bastion_public_ip" { value = module.compute.bastion_public_ip }
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "frontend_asg_name" { value = module.autoscaling_frontend.asg_name }
output "backend_asg_name" { value = module.autoscaling_backend.asg_name }
