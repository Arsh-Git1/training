output "instance_ids" {
  value = aws_instance.arsh_app[*].id
}
