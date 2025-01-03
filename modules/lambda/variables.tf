
variable "s3_bucket_name" {
  description = "The name of the S3 bucket to interact with"
  type        = string
}


variable "private_subnet_id" {
  description = "The ID of the private subnet for the Lambda functions"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the Lambda functions will run"
  type        = string
}
