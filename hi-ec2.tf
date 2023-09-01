resource "aws_instance" "hi-bastion" {
    ami = "ami-0d5d9d301c853a04a"
    instance_type = "t2.micro"
    subnet_id =  "${aws_subnet.hi-public-subnet.id}"
    vpc_security_gruop_ids = [aws_security_group.hi-main-server-sg.id]
    key_name = "hi-key"
    association_public_ip_address = false
    source_dest_check = false

    tags = {
        Name = "hi-main-server"
    }
}

# Create SG
## Create Bastion SG
resource "aws_security_group" "hi-bastion-sg" {
    vpc_id = "${aws_vpc.hi-vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "hi-sg"
    }
}

## Create Main Server SG
resource "aws_security_group" "hi-main-server-sg" {
    vpc_id = "${aws_vpc.hi-vpc.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.hi-bastion-sg.id]
    }

    ingress{
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 587
        to_port = 587
        protocol = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "hi-main-server-sg"
    }
}