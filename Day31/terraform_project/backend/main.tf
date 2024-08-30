# backend/main.tf

# Create S3 Bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "your-unique-bucket-name"
  acl    = "private"
  versioning {
    enabled = true
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
