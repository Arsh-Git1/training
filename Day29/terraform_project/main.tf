provider "aws" {
  region = "us-east-1"
}

module "ec2_s3" {
  source        = "./modules/ec2_s3_module"
  instance_type = "t2.micro"
  bucket_name   = "my-app-bucket"
}

output "ec2_id" {
  value = module.ec2_s3.ec2_id
}

output "bucket_name" {
  value = module.ec2_s3.bucket_name
}
