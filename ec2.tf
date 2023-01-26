//*****************************************************************************//
// PARTIE PROD
//*****************************************************************************//

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block_vpc[0]
  tags = {
    Name = "PROD VPC"
  }
  enable_dns_hostnames = true
}

//*****************************************************************************//
// PARTIE FRONT - PROD
//*****************************************************************************//

resource "aws_security_group" "sg_front" {
  name = "PROD front sg"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
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

resource "aws_subnet" "subnet_front" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr_block_subnet[0]
  availability_zone = "eu-west-3c"
  tags = {
    Name = "Subnet_front"
  }
  depends_on = [aws_internet_gateway.gw_front]
}
/*
resource "aws_network_interface" "NI_front" {
  subnet_id   = aws_subnet.subnet_front.id
  tags = {
    Name = "primary_network_interface"
  }
}
*/
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key= var.public_key 
}

resource "aws_internet_gateway" "gw_front" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_eip" "bar" {
  vpc = true
  count=2
  instance                  = aws_instance.my_ec2_instance_front[count.index].id 
  depends_on                = [aws_internet_gateway.gw_front]
}

resource "aws_instance" "my_ec2_instance_front" {
    count = 2
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    subnet_id = aws_subnet.subnet_front.id
    /*
    network_interface {
    network_interface_id = aws_network_interface.NI_front.id
    device_index         = 0
    }
    */
    //user_data = "${file("FILE/installapache.sh")}"
    vpc_security_group_ids = [aws_security_group.sg_front.id]
}


//*****************************************************************************//
// PARTIE MID - PROD
//*****************************************************************************//

resource "aws_security_group" "sg_mid" {
  name = "PROD mid sg"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "subnet_mid" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.cidr_block_subnet[1]
  availability_zone = "eu-west-3c"
  tags = {
    Name = "Subnet_mid"
  }
}

resource "aws_network_interface" "NI_mid" {
  subnet_id   = aws_subnet.subnet_mid.id
  tags = {
    Name = "mid_network_interface"
  }
}

/*
resource "aws_eip" "bar" {
  vpc = true
  instance                  = aws_instance.my_ec2_instance_mid.id
  depends_on                = [aws_internet_gateway.gw]
}
*/
resource "aws_instance" "my_ec2_instance_mid" {
    count = 2
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    subnet_id = aws_subnet.subnet_mid.id
    /*
    network_interface {
    network_interface_id = aws_network_interface.NI_mid.id
    device_index         = 0
    }
    */
    //user_data = "${file("FILE/installapache.sh")}"
    vpc_security_group_ids = [aws_security_group.sg_mid.id]
}