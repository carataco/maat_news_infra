terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "terraform-maat-news"
    key            = "terraform.tfstate"
    region         = "eu-south-2"
    use_lockfile   = true
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-south-2"
}