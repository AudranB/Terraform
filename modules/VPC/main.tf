resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.cidr_block_vpc}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_front" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr_block_subnet
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
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_internet_gateway" "gw_front" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_front.id
  }
  tags = {
    Name = "my_table"
  }
}
resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.my_vpc.id
  route_table_id = aws_route_table.my_table.id
}
/*
resource "aws_network_acl_association" "main" {
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.subnet_front.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.my_vpc.id
  egress {
   rule_no    = 120
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "icmp"
    action     = "allow"
    icmp_type  = -1
    icmp_code  = -1
  }

  ingress {
    rule_no    = 110
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "icmp"
    action     = "allow"
    icmp_type  = -1
    icmp_code  = -1
  }
}
*/
