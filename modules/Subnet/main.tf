resource "aws_subnet" "my_subnet" {
  vpc_id            = var.vpc_id
  cidr_block  = var.cidr_block
  # tags = {
  #   Name = "Subnet_"
  # }
  map_public_ip_on_launch = true
}