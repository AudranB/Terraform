output "MyVPC_id" {
  value = aws_vpc.my_vpc.id
}
output "MySubnet_id" {
  value = aws_subnet.subnet_front.id
}

output "My_vpc_SG" {
  value = aws_security_group.sg_front.id
}
