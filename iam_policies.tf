resource "aws_iam_role_policy_attachment" "basic_logging" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "lambda-s3-access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.ingestion_dev.arn,         
          "${aws_s3_bucket.ingestion_dev.arn}/*",

          aws_s3_bucket.ingestion_prod.arn,
          "${aws_s3_bucket.ingestion_prod.arn}/*"
        ]
      }
    ]
  })
}
