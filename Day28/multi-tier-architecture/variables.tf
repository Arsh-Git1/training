variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "rds_instance_type" {
  description = "RDS instance type"
  default     = "t3.micro"
}

variable "db_name" {
  description = "Database name"
  default     = "mydatabase"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  default     = "password123"
  # sensitive   = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "my-s3-bucket"
}
