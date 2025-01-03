# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS Managed Policies for Lambda
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


# Security Group for Lambda Function
resource "aws_security_group" "lambda_sg" {
  vpc_id = var.vpc_id

  # Ingress rules
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Lambda Function for Handling All HTTP Methods
resource "aws_lambda_function" "handler" {
  function_name = "api-handler"                # Name of the Lambda function
  runtime       = "python3.9"                  # Python runtime version
  handler       = "lambda_function.lambda_handler" # Entry point function
  role          = aws_iam_role.lambda_exec.arn # Role ARN for execution permissions

  # Reference the local .zip file
  
  filename = "${path.module}/lambda_code/lambda-code.zip"

  package_type = "Zip"
  # Pass environment variables
  environment {
    variables = {
      BUCKET_NAME = var.s3_bucket_name          # S3 bucket for storing data
    }
  }

  # VPC Configuration
  vpc_config {
    subnet_ids         = [var.private_subnet_id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}
