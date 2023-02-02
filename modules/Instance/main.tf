resource "aws_instance" "my_ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.VPC_secu_group_id]
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("./key/id_rsa")}"
        agent = false
        host = self.public_ip
    }
    
    provisioner "file" {
        source = "./FILE/index.html" // var.html_path_source
        destination = "/home/ubuntu/index.html" // var.html_path_dest
    }
    user_data = "${file("./FILE/installapache.sh")}"
}
