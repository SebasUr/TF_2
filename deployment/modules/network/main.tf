resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = { Name = "vpc-main" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "igw" }
}

resource "aws_subnet" "public" {
  for_each                = { for s in var.public_subnets : "${s.az}-${s.cidr}" => s }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = { Name = "public-${each.value.az}" }
}

resource "aws_subnet" "private" {
  for_each          = { for s in var.private_subnets : "${s.az}-${s.cidr}" => s }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = { Name = "private-${each.value.az}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "rt-public" }
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = var.create_nat_gateways ? aws_subnet.public : {}
  vpc      = true
  tags     = { Name = "nat-eip-${each.key}" }
}

resource "aws_nat_gateway" "this" {
  for_each      = var.create_nat_gateways ? aws_subnet.public : {}
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  tags          = { Name = "nat-${each.key}" }
  depends_on    = [aws_internet_gateway.this]
}

# Mapa de NAT Gateway por AZ para enrutar subredes privadas al NAT de su AZ
locals {
  natgw_per_az = var.create_nat_gateways ? {
    for k, s in aws_subnet.public : s.availability_zone => aws_nat_gateway.this[k].id
  } : {}
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.this.id
  tags     = { Name = "rt-private-${each.key}" }
}

resource "aws_route" "private_default" {
  # Solo crear rutas por defecto en privadas cuando se hayan creado NATs
  for_each               = var.create_nat_gateways ? aws_route_table.private : {}
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = lookup(local.natgw_per_az, aws_subnet.private[each.key].availability_zone, null)
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
