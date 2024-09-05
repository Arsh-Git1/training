# Multi-Tier Web Application Deployment Using Amazon ECS

## Project Objectives

- Set up an ECS Cluster using the Fargate launch type.
- Deploy a web application with multiple containers (frontend and backend).
- Enable direct communication between frontend and backend services.
- Configure networking and security with VPC, subnets, security groups, and IAM roles.
- Implement auto-scaling policies for ECS services.

## Configuration
# Directory structure
```bash
|
|-- modules
|   |-- ecs
|   |   |-- main.tf
|   |   |-- output.tf
|   |   `-- variables.tf
|   |-- iam
|   |   |-- main.tf
|   |   |-- output.tf
|   |   `-- variables.tf
|   |-- rds
|   |   |-- main.tf
|   |   |-- output.tf
|   |   `-- variables.tf
|   |-- sg
|   |   |-- main.tf
|   |   |-- output.tf
|   |   `-- variables.tf
|   `-- vpc
|       |-- main.tf
|       |-- output.tf
|       `-- variables.tf
|-- main.tf
|-- outputs.tf
`-- variables.tf

```

### 1. **VPC and Networking**

- Creates a VPC with public and private subnets.
- Configures an Internet Gateway for public subnet access.
![alt text](<image/Screenshot from 2024-09-05 12-13-43.png>)
![alt text](<image/Screenshot from 2024-09-05 12-14-29.png>)
![alt text](<image/Screenshot from 2024-09-05 12-14-43.png>)

### 2. **RDS Instance**

- Launches an RDS MySQL instance in a private subnet.
- Stores database credentials (password) in plaintext within the configuration (consider using AWS Secrets Manager or SSM Parameter Store in production).
![alt text](<image/Screenshot from 2024-09-05 12-16-49.png>)

### 3. **ECS Cluster and Services**

- Creates an ECS Cluster with Fargate launch type.
![alt text](<image/Screenshot from 2024-09-05 12-17-40.png>)

### 4. **IAM Roles**

- Defines IAM roles and policies for ECS task execution and task roles.
![alt text](<image/Screenshot from 2024-09-05 12-19-16.png>)
### 5. **Auto-Scaling Policies**

- Configures auto-scaling for frontend and backend services based on CPU and memory usage.
![alt text](<image/Screenshot from 2024-09-05 12-30-40.png>)

## steps

### 1. **Configure AWS CLI**

Ensure that the AWS CLI is installed and configured with appropriate credentials:

```bash
aws configure
```

### 2. **Initialize Terraform**

Initialize the Terraform working directory:

```bash
terraform init
```
![alt text](<image/Screenshot from 2024-09-05 12-31-38.png>)

### 3. **Plan the Deployment**

Generate an execution plan to review changes:

```bash
terraform plan
```
![alt text](<image/Screenshot from 2024-09-05 12-32-22.png>)
### 4. **Apply the Configuration**

Apply the Terraform configuration to deploy the infrastructure:

```bash
terraform apply
```
![alt text](<image/Screenshot from 2024-09-05 12-32-50.png>)
![alt text](<image/Screenshot from 2024-09-05 12-33-05.png>)
### 5.Cleaning Up

To delete all the resources created by Terraform, run:

```bash
terraform destroy
```
![alt text](<image/Screenshot from 2024-09-05 13-02-34.png>)
![alt text](<image/Screenshot from 2024-09-05 13-02-47.png>)