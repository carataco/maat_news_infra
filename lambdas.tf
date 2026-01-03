locals {
  lambdas = {
    ingest_bbc_news_int  = "BBC News Int RSS Ingestion"
    ingest_the_guardian = "The Guardian RSS Ingestion"
  }
}

# --------------------------------------------------
# Bootstrap ZIP (only used to create the Lambda)
# --------------------------------------------------
data "archive_file" "lambda_bootstrap" {
  type        = "zip"
  output_path = "${path.module}/lambda_bootstrap.zip"

  source {
    filename = "handler.py"
    content  = <<EOF
def lambda_handler(event, context):
    return {"status": "bootstrap"}
EOF
  }
}

# --------------------------------------------------
# Lambda functions (infra only, code ignored)
# --------------------------------------------------
resource "aws_lambda_function" "this" {
  for_each = local.lambdas

  function_name = each.key
  description   = each.value

  runtime = "python3.10"
  handler = "handler.lambda_handler"
  role    = aws_iam_role.lambda_exec.arn

  filename         = data.archive_file.lambda_bootstrap.output_path
  source_code_hash = data.archive_file.lambda_bootstrap.output_base64sha256

  timeout     = 15
  memory_size = 256

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.ingestion_prod.bucket
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]

    create_before_destroy = true
    prevent_destroy       = false
  }

  

}
