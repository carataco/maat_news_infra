locals {
  lambdas = {
    ingest_bbc_news_int = {
      description = "BBC News Int RSS Ingestion"
      env = {
        SOURCE_TYPE = "rss"
        SOURCE_ID   = "bbc_news_int"
        RSS_URL     = "https://feeds.bbci.co.uk/news/rss.xml?edition=int"
        TARGET_TYPE = "s3"
      }
    }

    ingest_the_guardian = {
      description = "The Guardian RSS Ingestion"
      env = {
        SOURCE_TYPE = "rss"
        SOURCE_ID   = "the_guardian"
        RSS_URL     = "https://www.theguardian.com/world/rss"
        TARGET_TYPE = "s3"
      }
    }
  }
}

# ============================
# Lambda Functions
# ============================
resource "aws_lambda_function" "this" {
  for_each = local.lambdas

  function_name = each.key
  description   = each.value.description

  runtime = "provided.al2"
  handler = "bootstrap"
  role    = aws_iam_role.lambda_exec.arn

  s3_bucket = "terraform-maat-artifacts"
  s3_key    = "lambda_bootstrap.zip"

  timeout     = 15
  memory_size = 256

  environment {
    variables = merge(
      {
        S3_BUCKET = aws_s3_bucket.ingestion_prod.bucket
      },
      each.value.env
    )
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

# ============================
# EventBridge Scheduled Rules
# ============================
resource "aws_cloudwatch_event_rule" "schedule" {
  for_each = local.lambdas

  name                = "${each.key}-schedule"
  description         = "Run ${each.key} Lambda every 30 minutes"
  schedule_expression = "rate(30 minutes)"  # runs every 30 min
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  for_each = local.lambdas

  rule      = aws_cloudwatch_event_rule.schedule[each.key].name
  target_id = each.key
  arn       = aws_lambda_function.this[each.key].arn
}

resource "aws_lambda_permission" "allow_event" {
  for_each = local.lambdas

  statement_id  = "AllowExecutionFromEventBridge-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[each.key].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule[each.key].arn
}