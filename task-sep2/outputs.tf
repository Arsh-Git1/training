# outputs.tf
output "vpc_id" {
  value = module.connection.vpc_id
}

output "public_subnet_ids" {
  value = module.connection.public_subnet_id
}

output "private_subnet_id" {
  value = module.connection.private_subnet_id
}

output "master_instance_id" {
  value = module.computation.master_instance_id
}

output "worker_instance_ids" {
  value = module.computation.worker_instance_ids
}

output "s3_bucket_name" {
  value = module.storage.bucket_name
}
