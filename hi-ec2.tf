resource "aws_instance" "hi-bastion" {
    ami = "ami-0d5d9d301c853a04a"
    instance_type = "t2.micro"
    subnet_id =  ${aws_subnet.hi-subenet-2a.id}
}