output "ec2_id" {
  value = aws_instance.ec2.id
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

