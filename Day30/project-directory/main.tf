provider "aws" {
  region = "us-east-1"
}

module "aws_infrastructure" {
  source         = "./modules/aws_infrastructure"
  ami_id          = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  instance_type   = "t2.micro"
  key_name         = "your-key-pair-name"
  bucket_name      = "your-bucket-name"
  instance_name    = "my-ec2-instance"
}

resource "null_resource" "apache_setup" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/your-key.pem")
      host        = module.aws_infrastructure.instance_public_ip
    }
  }

  provisioner "local-exec" {
    command = "echo 'EC2 instance successfully provisioned with Apache.'"
  }
}
