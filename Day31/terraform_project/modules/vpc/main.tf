resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  ...
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  ...
}
