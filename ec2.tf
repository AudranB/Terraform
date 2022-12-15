resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "tf-example"
  }
}
/*
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-3c"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}
*/
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key= var.public_key 
}


resource "aws_security_group" "demo-sg" {
  name = "sec-grp"
  description = "Allow HTTP and SSH traffic via Terraform"

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

resource "aws_instance" "my_ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
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
