// CREATION VPC - VPC des mes 3 environnemnts PROD | PRE-PROD | DEV //
module "my_vpc" {
  source = "./modules/VPC"
  cidr_block_vpc = var.cidr_block_vpc
  cidr_block_subnet = var.cidr_block_subnet[0]
}
//CREATION PAIR KEY//
/*resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key= var.public_key 
}
*/
/*
// A VOIR //
resource "aws_internet_gateway" "gw_front" {
  vpc_id = module.my_vpc.MyVPC_id
}

resource "aws_eip" "bar" {
  vpc = true
  count = 3
  instance                  = module.my_ec2_instance[count.index].My_instance
  depends_on                = [aws_internet_gateway.gw_front]
}
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
                                          FRONT PROD
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module "my_ec2_instance" {
  count = 3
  source = "./modules/Instance"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_vpc.MySubnet_id
  VPC_secu_group_id = module.my_vpc.My_vpc_SG
}





resource "aws_security_group" "sg_mid" {
  name = "PROD mid sg"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id = module.my_vpc.MyVPC_id

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
  vpc_id            = module.my_vpc.MyVPC_id
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
/*resource "aws_instance" "my_ec2_instance_mid" {
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
    
    //user_data = "${file("FILE/installapache.sh")}"
    vpc_security_group_ids = [aws_security_group.sg_mid.id]
}*/
