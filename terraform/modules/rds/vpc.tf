resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
}
