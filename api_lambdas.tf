# Get current account ID dynamically
data "aws_caller_identity" "current" {}

# Lambda execution role
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Define your Lambdas
locals {
  lambdas = {
    "articles" = {
      filename = "lambda_bootstrap.zip"
      description = "Articles API Endpoint"
    }
    "authors" = {
      filename = "lambda_bootstrap.zip"
      description = "Authors API Endpoint"
    }
  }
}

resource "aws_lambda_function" "api_endpoints" {
  for_each = local.lambdas

  function_name = "api_endpoint_${each.key}"
  description   = each.value.description
  runtime       = "provided.al2"
  handler       = "bootstrap"
  role          = aws_iam_role.lambda_exec.arn

  s3_bucket = "terraform-maat-artifacts"
  s3_key    = each.value.filename

  timeout     = 15
  memory_size = 256

  environment {
    variables = {}
  }

  lifecycle {
    ignore_changes       = [filename, source_code_hash, s3_bucket, s3_key, s3_object_version]
    create_before_destroy = true
  }
}

# API Gateway (HTTP API v2)
resource "aws_apigatewayv2_api" "main" {
  name          = "maat_news_api"
  protocol_type = "HTTP"
}

# Create routes for each Lambda
resource "aws_apigatewayv2_route" "routes" {
  for_each = local.lambdas

  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /v1/${each.key}"  # maps to /v1/articles, /v1/authors

  target = "integrations/${aws_apigatewayv2_integration.lambda[each.key].id}"
}

# Integrations for each Lambda
resource "aws_apigatewayv2_integration" "lambda" {
  for_each = local.lambdas

  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.api_endpoints[each.key].arn
  payload_format_version = "2.0"
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "api_invoke" {
  for_each      = local.lambdas
  statement_id  = "apigw-v1-${each.key}-get"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_endpoints[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-south-2:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.main.id}/*/GET/v1/${each.key}"
}

# Deploy the API
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "v1"
  auto_deploy = true
}
