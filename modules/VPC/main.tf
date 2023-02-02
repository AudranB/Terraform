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
  map_public_ip_on_launch = true
}

resource "aws_security_group" "sg_front" {
  name = "front sg"
  description = "Allow HTTP/S and SSH traffic via Terraform"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_acl_association" "main" {
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.subnet_front.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.my_vpc.id
  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}