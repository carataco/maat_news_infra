resource "aws_apigatewayv2_api" "my_api" {
  name          = "maat-news-api"
  protocol_type = "HTTP"
}