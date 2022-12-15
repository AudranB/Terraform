variable "key_name" {}
variable "public_key" {}
variable "ami" {}
variable "instance_type" {}
variable "cidr_block" {
    type=list
}
variable "name_sg"{}
variable "private_ip" {
    type = map 
    default = {
        front = ["172.16.10.100","172.16.10.110"]
        mid = ["172.16.20.100","172.16.20.110"]
        back= ["172.16.30.100"]
    }
}




/*
variable "SG_rules" {
    type = map 
    default = {
        http = [80,80,"tcp","0.0.0.0/0"]
        ssh = [22,22,"tcp","0.0.0.0/0"]
        block= [0,0,"-1","0.0.0.0/0"]
    }
}
*/