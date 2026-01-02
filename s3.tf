resource "aws_s3_bucket" "ingestion_dev" {
  bucket = "raw-maat-news-dev"

  tags = {
    Project = "Maat News"
    Env     = "dev"
  }
}

resource "aws_s3_bucket" "ingestion_prod" {
  bucket = "raw-maat-news-prod"

  tags = {
    Project = "Maat News"
    Env     = "prod"
  }
}
