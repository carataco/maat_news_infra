
resource "aws_apigatewayv2_integration" "get_articles" {
  api_id                 = aws_apigatewayv2_api.my_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:lambda:eu-south-2:791303507900:function:api_endpoint_articles"
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_integration" "get_authors" {
  api_id                 = aws_apigatewayv2_api.my_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:lambda:eu-south-2:791303507900:function:api_endpoint_authors"
  payload_format_version = "2.0"
}
