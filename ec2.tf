resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block[0]
  tags = {
    Name = "tf-example"
  }
  enable_dns_hostnames = true
}
resource "aws_security_group" "demo-sg" {
  name = "sec-grp"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr_block[0]
  availability_zone = "eu-west-3c"
  tags = {
    Name = "tf-example"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = [var.private_ip["front"][0]]
  security_groups = [aws_security_group.demo-sg.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key= "${file("key/key_ssh.pub")}" 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

}

resource "aws_eip" "bar" {
  vpc = true
  instance                  = aws_instance.my_ec2_instance.id
  depends_on                = [aws_internet_gateway.gw]
}

resource "aws_instance" "my_ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
    }
    user_data = <<EOF
#!/bin/bash
sudo yum -y update && sudo yum -y upgrade
sudo yum -y install httpd
sudo systemctl start httpd
sudo touch /var/www/html/index.html
sudo echo "<html><body><h1>Vive Medy </h1></body></html>" > /var/www/html/index.html
sudo yum systemctl reload httpd
EOF
}
/*
data "local_file" "foo" {
    filename = ""
}
*/