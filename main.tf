terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Ensure you're using AWS provider version 5.0 or later
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr       = var.vpc_cidr
  region         = var.region
  lambda_sg_id   = module.lambda.lambda_sg_id
}

module "s3" {
  source = "./modules/s3"
}

module "api_gateway" {
  source          = "./modules/api_gateway"
  lambda_arns     = module.lambda.lambda_arns # Pass Lambda ARNs from the lambda module
  vpc_endpoint_id = module.vpc.vpc_endpoint_id
  s3_bucket_name  = module.s3.bucket_name
  region          = var.region
}

module "lambda" {
  source            = "./modules/lambda"
  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  s3_bucket_name    = module.s3.bucket_name
}

# Output the Lambda ARN for debugging and validation
output "lambda_arns" {
  value = module.lambda.lambda_arns
}

