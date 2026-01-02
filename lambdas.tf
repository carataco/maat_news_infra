locals {
  lambdas = {
    ingest_bbc_news_int  = "BBC News Int RSS Ingestion"
    ingest_the_guardian = "The Guardian RSS Ingestion"
  }
}

resource "aws_lambda_function" "this" {
  for_each = local.lambdas

  function_name = each.key
  description   = each.value

  runtime = "python3.12"
  handler = "handler.handler"
  role    = aws_iam_role.lambda_exec.arn

  filename         = "${path.module}/lambdas/placeholder/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambdas/placeholder/lambda_function.zip")

  timeout     = 3
  memory_size = 128

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.ingestion_prod.bucket
    }
  }
}
