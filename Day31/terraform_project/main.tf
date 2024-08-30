# main.tf

terraform {
  backend "s3" {
    bucket         = "your-unique-bucket-name"
    key            = "terraform/state"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
  }
}

# Provider configuration
provider "aws" {
  region = "us-west-2"
}
