resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}

# Create VPC Endpoint for API Gateway
resource "aws_vpc_endpoint" "gateway" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.execute-api"
  vpc_endpoint_type = "Interface" # Use Interface for execute-api

  subnet_ids         = [aws_subnet.private.id]
  security_group_ids = [var.lambda_sg_id] # Use the passed variable
  private_dns_enabled = true
}
