output "vpc_id" {
  value = aws_vpc.arsh_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.arsh_public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.arsh_private[*].id
}
