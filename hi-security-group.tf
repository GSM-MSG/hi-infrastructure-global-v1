
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