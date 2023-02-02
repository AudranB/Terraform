resource "aws_subnet" "subnet_front" {
  vpc_id            = module.my_vpc.id
  cidr_block        = var.cidr_block_subnet
  tags = {
    Name = "Subnet_front"
  }
  map_public_ip_on_launch = true
}