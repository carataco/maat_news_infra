resource "aws_lambda_function" "api_endpoint_articles" {


  function_name = "api_endpoint_articles"
  description   = "Articles API Endpoint"

  runtime = "provided.al2"
  handler = "bootstrap"
  role    = aws_iam_role.lambda_exec.arn

  s3_bucket = "terraform-maat-artifacts"
  s3_key    = "lambda_bootstrap.zip"

  timeout     = 15
  memory_size = 256

  environment {
    variables = {}
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      s3_bucket,
      s3_key,
      s3_object_version
    ]
    create_before_destroy = true
  }
}

resource "aws_lambda_function" "api_endpoint_authors" {


  function_name = "api_endpoint_authors"
  description   = "Authors API Endpoint"

  runtime = "provided.al2"
  handler = "bootstrap"
  role    = aws_iam_role.lambda_exec.arn

  s3_bucket = "terraform-maat-artifacts"
  s3_key    = "lambda_bootstrap.zip"

  timeout     = 15
  memory_size = 256

  environment {
    variables = {}
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      s3_bucket,
      s3_key,
      s3_object_version
    ]
    create_before_destroy = true
  }
}