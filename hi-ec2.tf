resource "aws_instance" "hi-bastion" {
    ami = "ami-04cebc8d6c4f297a3"
    instance_type = "t2.micro"
    subnet_id =  "${aws_subnet.hi-public-subnet-2a.id}"
    vpc_security_group_ids = [aws_security_group.hi-bastion-sg.id]
    key_name = "hi-key"

    tags = {
        Name = "hi-bastion"
    }
}

resource "aws_instance" "hi-main-server" {
    ami = "ami-04cebc8d6c4f297a3"
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
