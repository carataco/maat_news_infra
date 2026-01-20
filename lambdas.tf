locals {
  lambdas = {
    ingest_bbc_news_int  = "BBC News Int RSS Ingestion"
    ingest_the_guardian = "The Guardian RSS Ingestion"
  }
}

# --------------------------------------------------
# Lambda functions (infra only, Go runtime)
# --------------------------------------------------
resource "aws_lambda_function" "this" {
  for_each = local.lambdas

  function_name = each.key
  description   = each.value

  runtime = "provided.al2"
  handler = "bootstrap"
  role    = aws_iam_role.lambda_exec.arn

  # --- Bootstrap code from S3 (placeholder only) ---
  s3_bucket = "terraform-maat-artifacts"
  s3_key    = "lambda_bootstrap.zip"

  timeout     = 15
  memory_size = 256

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.ingestion_prod.bucket
    }
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