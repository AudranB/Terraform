// CREATION VPC - VPC des mes 3 environnemnts PROD | PRE-PROD | DEV  10.10.0.0/16 //
module "my_vpc" {
  source = "./modules/VPC"
  cidr_block_vpc = var.cidr_block_vpc
}
//CREATION PAIR KEY//
resource "aws_key_pair" "aws-terraform-key" {
  key_name   = var.key_name
  public_key = "${file("key/id_rsa.pub")}"
}

// Création de mes 9 subnet correspondant a 3 (environnement) x 3 (front / mid / back)
module "my_subnet" {
  source = "./modules/Subnet"
  count = 9
  vpc_id = module.my_vpc.MyVPC_id
  cidr_block  = var.cidr_block_subnet[count.index]
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
                                          FRONT PROD
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module "sg_front" {
    source = "./modules/SG/SG_FRONT"
  vpc_id = module.my_vpc.MyVPC_id
}
module "my_ec2_instance_front" {
  count = 2
  source = "./modules/Instance/Instance_front"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_subnet[0].MySubnet_id
  VPC_secu_group_id = module.sg_front.My_vpc_SG_front
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
                                          MID PROD
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module "sg_mid" {
  source = "./modules/SG/SG_MID"
  vpc_id = module.my_vpc.MyVPC_id
}

module "my_ec2_instance_mid" {
  count = 2
  source = "./modules/Instance/Instance_mid"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_subnet[1].MySubnet_id
  VPC_secu_group_id = module.sg_mid.My_vpc_SG_mid
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
                                          BACK PROD
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module "sg_back" {
  source = "./modules/SG/SG_BACK"
  vpc_id = module.my_vpc.MyVPC_id
}

module "my_ec2_instance_back" {
  count = 2
  source = "./modules/Instance/Instance_back"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_subnet[2].MySubnet_id
  VPC_secu_group_id = module.sg_back.My_vpc_SG_back
}




# resource "aws_security_group" "sg_mid" {
#   name = "PROD mid sg"
#   description = "Allow HTTP and SSH traffic via Terraform"
#   vpc_id = module.my_vpc.MyVPC_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "ICMP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#     ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_subnet" "subnet_mid" {
#   vpc_id            = module.my_vpc.MyVPC_id
#   cidr_block        = var.cidr_block_subnet[1]
#   availability_zone = "eu-west-3c"
#   tags = {
#     Name = "Subnet_mid"
#   }
# }

# resource "aws_network_interface" "NI_mid" {
#   subnet_id   = aws_subnet.subnet_mid.id
#   tags = {
#     Name = "mid_network_interface"
#   }
# }

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
