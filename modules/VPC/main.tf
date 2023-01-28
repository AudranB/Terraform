resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.cidr_block_vpc}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_front" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr_block_subnet
  availability_zone = "eu-west-3c"
  tags = {
    Name = "Subnet_front"
  }
}

resource "aws_security_group" "sg_front" {
  name = "PROD front sg"
  description = "Allow HTTP/S and SSH traffic via Terraform"
  vpc_id = aws_vpc.my_vpc.id
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}