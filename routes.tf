
resource "aws_apigatewayv2_route" "get_articles_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "GET /v1/articles"
  target    = "integrations/${aws_apigatewayv2_integration.get_articles.id}"
  authorization_type  = "JWT"
  authorizer_id       = "j29jtj"
}

resource "aws_apigatewayv2_route" "get_authors_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "GET /v1/authors"
  target    = "integrations/${aws_apigatewayv2_integration.get_authors.id}"
  authorization_type  = "JWT"
  authorizer_id       = "j29jtj"
}
