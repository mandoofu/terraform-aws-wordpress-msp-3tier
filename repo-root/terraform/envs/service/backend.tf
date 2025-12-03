terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "terraform-state-a22f0d4f"
    key            = "service/terraform.tfstate"
    region         = "ap-northeast-3"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
