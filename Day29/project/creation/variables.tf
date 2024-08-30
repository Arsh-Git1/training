variable "bucket" {
    type = string
    default = "arsh-terraform-bucket"
}

variable "instance_name" {
    type = string
    default = "arsh-app"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "region" {
    type = string
    default = "ap-south-1"
}
