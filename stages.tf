resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.my_api.id
  name        = "dev"
  auto_deploy = true
  tags        = {}
  default_route_settings {
    throttling_rate_limit = 0.0167       
  }
}
