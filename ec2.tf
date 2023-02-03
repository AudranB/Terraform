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
  count = 3
  source = "./modules/Instance/Instance_front"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_subnet[count.index*3].MySubnet_id
  VPC_secu_group_id = module.sg_front.My_vpc_SG_front
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
                                          MID PROD
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module "sg_mid" {
  count = 3
  source = "./modules/SG/SG_MID"
  vpc_id = module.my_vpc.MyVPC_id
  cidr_blocks = var.cidr_block_subnet[count.index*3]
}

module "my_ec2_instance_mid" {
  count = 3
  source = "./modules/Instance/Instance_mid"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_subnet[count.index*3+1].MySubnet_id
  VPC_secu_group_id = module.sg_mid[count.index].My_vpc_SG_mid
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
                                          BACK PROD
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module "sg_back" {
  count = 3
  source = "./modules/SG/SG_BACK"
  vpc_id = module.my_vpc.MyVPC_id
  cidr_blocks = var.cidr_block_subnet[count.index*3 +1]
}

module "my_ec2_instance_back" {
  count = 3
  source = "./modules/Instance/Instance_back"
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = module.my_subnet[count.index*3 +2].MySubnet_id
  VPC_secu_group_id = module.sg_back[count.index].My_vpc_SG_back
}