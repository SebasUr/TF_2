resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = var.instance_type_bastion
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.sg_bastion_id]
  tags                        = { Name = "bastion" }
}


