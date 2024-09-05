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