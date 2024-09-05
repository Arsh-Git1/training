# modules/computation/outputs.tf
output "master_instance_id" {
  value = aws_instance.master.id
}

output "worker_instance_ids" {
  value = aws_instance.workers[*].id
}
