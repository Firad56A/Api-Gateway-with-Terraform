output "api_gateway_endpoint" {
  description = "Private API Gateway endpoint"
  value       = module.api_gateway.private_endpoint
}

