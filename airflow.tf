# Execution role for MWAA environment (already managed in Terraform)
resource "aws_iam_role" "airflow_env_role" {
  name = "AmazonMWAA-maat-news-mwaa-env-2Urdi8"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "airflow-env.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      path,
      assume_role_policy,
      tags,
      inline_policy,
    ]
  }
}

# MWAA Environment
resource "aws_mwaa_environment" "maat_news" {
  name                = "maat-news-mwaa-env"
  execution_role_arn  = aws_iam_role.airflow_env_role.arn
  airflow_version     = "3.0.6"
  environment_class   = "mw1.micro"
  source_bucket_arn   = "arn:aws:s3:::airflow-maat-news"
  dag_s3_path         = "dags/"
  requirements_s3_path = "requirements.txt"

  network_configuration {
    subnet_ids         = ["subnet-07f8dd9659b50cc59", "subnet-02b3f18383c0400a7"]
    security_group_ids = ["sg-0c188feea7fc49ae4"]
  }

    logging_configuration {
    task_logs {
        enabled   = true
        log_level = "INFO"
    }
    dag_processing_logs {
        enabled   = false
        log_level = "WARNING"
    }
    scheduler_logs {
        enabled   = false
        log_level = "WARNING"
    }
    webserver_logs {
        enabled   = false
        log_level = "WARNING"
    }
    worker_logs {
        enabled   = false
        log_level = "WARNING"
    }
    }

  webserver_access_mode            = "PUBLIC_ONLY"
  min_workers                      = 1
  max_workers                      = 1
  weekly_maintenance_window_start  = "MON:20:00"
  schedulers                        = 1
  min_webservers                    = 1
  max_webservers                    = 1

  # Optional: prevent Terraform from touching the AWS-managed service role
  depends_on = [aws_iam_role.airflow_env_role]
}