output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.gateway.id
}
