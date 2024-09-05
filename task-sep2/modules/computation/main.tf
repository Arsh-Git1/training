# modules/computation/main.tf
resource "aws_instance" "master" {
  ami           = var.master_ami
  instance_type = "t2.medium"
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]
  key_name       = var.key_name

  tags = {
    Name = "arsh-ecom-master-node"
  }
}

resource "aws_instance" "workers" {
  count         = var.worker_count
  ami           = var.worker_ami
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]
  key_name       = var.key_name

  tags = {
    Name = "arsh-ecom-worker-node-${count.index}"
  }
}
