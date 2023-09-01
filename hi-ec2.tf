resource "aws_instance" "hi-bastion" {
    ami = "ami-0d5d9d301c853a04a"
    instance_type = "t2.micro"
    subnet_id =  "${aws_subnet.hi-public-subnet-2a.id}"
    vpc_security_group_ids = [aws_security_group.hi-bastion-sg.id]
    key_name = "hi-key"
    associate_public_ip_address = false
    source_dest_check = false

    tags = {
        Name = "hi-main-server"
    }
}

resource "aws_instance" "hi-main-server" {
    ami = "ami-0d5d9d301c853a04a"
    instance_type = "t3.micro"
    subnet_id = "${aws_subnet.hi-private-subnet-2a.id}"
    vpc_security_group_ids = [aws_security_group.hi-main-server-sg.id]
    key_name = "hi-key"
    associate_public_ip_address = false
    source_dest_check = false
    
    tags = {
        Name = "hi-main-server"
    }
}
