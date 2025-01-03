output "lambda_arns" {
  value = [aws_lambda_function.handler.arn]
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id
}