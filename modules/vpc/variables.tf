variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "lambda_sg_id" {
  description = "The security group ID for Lambda"
  type        = string
}