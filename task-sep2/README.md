# Project: Modular E-Commerce Application Deployment with S3 Integration 

## Project Duration: 8 Hours 

### Project Overview: 
In this project, participants will deploy a modular e-commerce application using AWS services and DevOps tools. The application will be set up to fetch static assets from an S3 bucket. Participants will use Terraform to manage infrastructure as code with modularization, Docker for containerization, Kubernetes for orchestration, and Helm for deployments. The goal is to create a scalable, maintainable solution that integrates various AWS services and DevOps practices. 

### Project Objectives: 

Modular Infrastructure: Use Terraform to create and manage modular infrastructure components. 

Static Asset Storage: Store and fetch static assets from an S3 bucket. 

Containerization: Package the application using Docker. 

Orchestration: Deploy the application on Kubernetes. 

CI/CD Pipeline: Automate the build and deployment process using Jenkins. 

Configuration Management: Use Ansible for configuration management. 

Deployment: Deploy the application using Helm charts. 

AWS Resources: Utilize AWS EC2 free tier instances for deployment


```
├── modules
│   ├── computation
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── connection
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── main.tf
│   │   └── outputs.tf
│   └── storage
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
```
### main.tf:
```
# main.tf
module "connection" {
  source = "./modules/connection"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  public_subnet_az    = "ap-northeast-2a"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_az   = "ap-northeast-2b"
}

module "computation" {
  source             = "./modules/computation"
  master_ami         = "ami-05d2438ca66594916"  
  worker_ami         = "ami-05d2438ca66594916"  
  worker_count       = 2
  subnet_id          = module.connection.public_subnet_id
  security_group_id  = module.connection.security_group_id
  key_name           = "arsh-tk-sep2"
}

module "storage" {
  source           = "./modules/storage"
  bucket_name      = "arsh-ecom-bucket"  
  # file_paths       = ["/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/index.html", "/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/script.js"]
  # file_sources     = ["/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/styles.css", "/home/einfochips/Training-Assessment-Task/E-commerce/ecom-site/logo.png"]
}
```
### providers.tf
```
# provider.tf
provider "aws" {
  region = "ap-northeast-2"  
}
```

### computation/main.tf:
```
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
```
### computation/variables.tf:
```
# modules/computation/variables.tf
variable "master_ami" {
  description = "AMI ID for the master node."
  type        = string
}

variable "worker_ami" {
  description = "AMI ID for the worker nodes."
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes."
  type        = number
}

variable "subnet_id" {
  description = "The ID of the subnet where instances will be launched."
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with instances."
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access."
  type        = string
}
```
### computation/outputs.tf:
```
# modules/computation/outputs.tf
output "master_instance_id" {
  value = aws_instance.master.id
}

output "worker_instance_ids" {
  value = aws_instance.workers[*].id
}
```

### connection/main.tf:
```
# Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "arsh-ecom-vpc"
  }
}

# Define the Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "arsh-ecom-internet-gateway1"
  }
}

# Define the Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_subnet_az
  map_public_ip_on_launch = true
  tags = {
    Name = "arsh-ecom-public-subnet1"
  }
}

# Define the Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_subnet_az
  tags = {
    Name = "arsh-ecom-private-subnet2"
  }
}

# Define the Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "arsh-ecom-public-route-table1"
  }
}

# Define the Route Table Association for Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Define Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "arsh-ecom-security-group1"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "arsh-ecom-security-group1"
  }
}
```

### sg/variables.tf:
```
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_subnet_az" {
  description = "Availability zone for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "private_subnet_az" {
  description = "Availability zone for the private subnet"
  type        = string
}

```

### sg/outputs.tf:
```
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.ig.id
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

```

### iam/main.tf:

```
resource "aws_iam_role" "arsh_ec2_role" {
  name = "arsh-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "arsh-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "arsh_ec2_policy_attachment" {
  role       = aws_iam_role.arsh_ec2_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
```


### iam/outputs.tf:
```
output "iam_role_arn" {
  value = aws_iam_role.arsh_ec2_role.arn
}
```

### storage/main.tf:
```
# modules/storage/main.tf
# resource "aws_s3_bucket" "static_assets" {
#   bucket = var.bucket_name
#   # acl    = "public-read"

#   tags = {
#     Name = "arsh-s3-ecom-bucket"
#   }
# }

# resource "aws_s3_bucket_object" "sample_files" {
#   count   = length(var.file_paths)
#   bucket  = aws_s3_bucket.static_assets.bucket
#   key     = element(var.file_paths, count.index)
#   source  = element(var.file_sources, count.index)
#   acl     = "public-read"
# }

# # modules/storage/main.tf
# resource "aws_s3_bucket" "static_assets" {
#   bucket = var.bucket_name
#   # acl    = "public-read"  

#   tags = {
#     Name = "static-assets-bucket"
#   }
# }

# resource "aws_s3_object" "sample_files" {
#   count   = length(var.file_paths)
#   bucket  = aws_s3_bucket.static_assets.bucket
#   key     = element(var.file_paths, count.index)
#   source  = element(var.file_sources, count.index)
#   acl     = "public-read"  # Ensure this matches with your bucket's ACL settings
# }

# modules/storage/main.tf
resource "aws_s3_bucket" "static_assets" {
  bucket = var.bucket_name
  # acl    = "private"  

  tags = {
    Name = "arsh-ecom-assets-bucket"
  }
}

# resource "aws_s3_object" "sample_files" {
#   count   = length(var.file_paths)
#   bucket  = aws_s3_bucket.static_assets.bucket
#   key     = element(var.file_paths, count.index)
#   source  = element(var.file_sources, count.index)
#   acl     = "private"  
# }

```

### storage/variables.tf:
```
# modules/storage/variables.tf
variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

# variable "file_paths" {
#   description = "List of file paths in the S3 bucket."
#   type        = list(string)
# }

# variable "file_sources" {
#   description = "List of local file paths to upload."
#   type        = list(string)
# }
```

### storage/outputs.tf:
```
# modules/storage/outputs.tf
output "bucket_name" {
  value = aws_s3_bucket.static_assets.bucket
}
```
![alt text](<images/Screenshot from 2024-09-02 16-32-16.png>)
![alt text](<images/Screenshot from 2024-09-02 16-32-30.png>)
![alt text](<images/Screenshot from 2024-09-02 16-33-44.png>)
![alt text](<images/Screenshot from 2024-09-02 16-33-56.png>)

### index.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Display Image</title>
    <style>
        body {
            text-align: center;
        }
        #access-section {
            text-align: left;
            margin-left: 20px;
        }
        #image {
            display: none;
            margin-top: 20px;
            width: 500px;
            height: auto;
        }
    </style>
</head>
<body>
    <h1>Welcome to My E-Commerce webapp.</h1>
    <p>You can buy many things here.</p>

    <div id="access-section">
        <p>To access S3 bucket image:</p>
        <button id="showImageBtn">Show Image</button>
    </div>

    <img src="nginx-webapp.jpg" alt="A description of the image">
</body>
</html>
```
### This is my nginx.conf file:
```
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}

```

### Dockerfile:
```
#Taking the base image alpine form nginx 
FROM nginx:alpine

#Copying the all congiduration updated file
COPY nginx.conf /etc/nginx/nginx.conf

#Copying the base index file created for nginx
COPY index.html /usr/share/nginx/html/index.html
#Exposing the port
EXPOSE 80

#Running the command for nginx
CMD ["nginx", "-g", "daemon off;"]

```

### This is my Jenkinsfile:
```
node {
    def dockerRegistry = 'https://registry.hub.docker.com'
    def dockerCredentialsId = 'dockerhub-credentials-id'
    def imageName = 'arshshaikh777/ecom-app'
    def imageTag = 'tagname'
    def image

    try {
        stage('Source Code Checkout') {
            checkout([
                $class: 'GitSCM',
                branches: [[name: '*/main']],
                doGenerateSubmoduleConfigurations: false,
                extensions: [],
                userRemoteConfigs: [[url: 'https://github.com/Arsh-Git1/FinalTk-Docker.git']]
            ])
        }

        stage('Build Docker Image') {
            image = docker.build("${imageName}:${imageTag}")
        }

        stage('Push Docker Image') {
            docker.withRegistry("${dockerRegistry}", "${dockerCredentialsId}") {
                image.push()
            }
        }
    } catch (Exception e) {
        currentBuild.result = 'FAILURE'
        echo "Pipeline failed: ${e.message}"
    } finally {
        echo "Cleaning up workspace..."
        cleanWs()
    }
}
```



### Below is my main.yaml:
```
---
- name: Deploy Kubernetes scripts to control plane and data plane
  hosts: all
  become: yes

  tasks:
    - name: copying master.sh to control plane
      ansible.builtin.copy:
        src: master.sh
        dest: /home/{{ ansible }}/master.sh
        mode: '0755'
      when: "'controlplane' in group_names"

    - name: copying worker.sh to data plane
      ansible.builtin.copy:
        src: worker.sh
        dest: /home/{{ ansible }}/worker.sh
        mode: '0755'
      when: "'dataplane' in group_names"

    - name: run worker.sh on data plane
      ansible.builtin.shell: /home/{{ ansible }}/worker.sh
      when: "'dataplane' in group_names"

    - name: run master.sh on control plane
      ansible.builtin.shell: /home/{{ ansible }}/master.sh
      when: "'controlplane' in group_names"

```

### Master.sh:
```
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
kubeadm init
sudo apt-mark hold kubelet kubeadm kubectl
sudo apt-get install -y containerd
sudo systemctl enable containerd --now
sudo sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get nodes 
```
### Worker.sh:
```
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list    
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
sudo apt-get update
sudo apt-get install -y containerd
sudo systemctl enable containerd --now
sudo sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```


