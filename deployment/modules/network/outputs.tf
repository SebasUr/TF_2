output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = [for s in aws_subnet.public : s.id] }
output "private_subnet_ids" { value = [for s in aws_subnet.private : s.id] }
output "public_subnet_cidrs" { value = [for s in aws_subnet.public : s.cidr_block] }
output "private_subnet_cidrs" { value = [for s in aws_subnet.private : s.cidr_block] }

# New: maps cidr_block => subnet id for deterministic selection
output "public_subnets_by_cidr" {
  value = { for k, s in aws_subnet.public : s.cidr_block => s.id }
}
output "private_subnets_by_cidr" {
  value = { for k, s in aws_subnet.private : s.cidr_block => s.id }
}
