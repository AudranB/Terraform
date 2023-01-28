resource "aws_instance" "my_ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.VPC_secu_group_id]
    /*
    network_interface {
    network_interface_id = aws_network_interface.NI_front.id
    device_index         = 0
    }
    */
    //user_data = "${file("FILE/installapache.sh")}"

}