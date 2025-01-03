variable "lambda_arns" {
  description = "ARNs of the Lambda functions"
  type = list(string)
}

variable "vpc_endpoint_id" {
  type = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "region" {
  description = "AWS region for API Gateway"
  type        = string
}
