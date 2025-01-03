resource "aws_api_gateway_rest_api" "private" {
  name = "PrivateAPI"
}

resource "aws_api_gateway_resource" "items" {
  rest_api_id = aws_api_gateway_rest_api.private.id
  parent_id   = aws_api_gateway_rest_api.private.root_resource_id
  path_part   = "items"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.private.id
  resource_id   = aws_api_gateway_resource.items.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.private.id
  resource_id             = aws_api_gateway_resource.items.id
  http_method             = aws_api_gateway_method.post_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST" # Ensure this matches the API Gateway HTTP method
  uri                     = "arn:aws:apigateway:eu-north-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-north-1:381491921631:function:api-handler/invocations"

  depends_on = [
    aws_api_gateway_method.post_method
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.private.id

  depends_on = [
    aws_api_gateway_integration.post_integration
  ]
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.private.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "dev"

  variables = {
    "lambdaAlias" = "live" # Optional example variable
  }
}

output "private_endpoint" {
  value = aws_api_gateway_stage.dev.invoke_url
}

output "deployment_id" {
  value = aws_api_gateway_deployment.deployment.id
}

output "post_method_id" {
  value = aws_api_gateway_method.post_method.id
}
