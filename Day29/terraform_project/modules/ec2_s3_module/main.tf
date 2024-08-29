resource "aws_instance" "ec2" {
  ami           = "ami-12345678"  # Replace with a valid AMI for your region
  instance_type = var.instance_type

  tags = {
    Name = "MyInstance"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
}
