data "aws_availability_zones" "available" {
    state = "available"
}


resource "aws_vpc" "hi-vpc"{
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"

    tags = {
        Name = "hi-vpc"
    }
}

# Create Subnet Public
resource "aws_subnet" "hi-public-subnet-2a" {
    vpc_id = aws_vpc.hi-vpc.id
    cidr_block = "192.168.0.0/20"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        "Name" = "hi-public-subnet-2a"
    }
}

## Create Subnet Private
resource "aws_subnet" "hi-private-subnet-2a" {
    vpc_id = aws_vpc.hi-vpc.id
    cidr_block = "192.168.16.0/20"
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
        "Name" = "sms-private-subnet-2a"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "hi-igw" {
    vpc_id = aws_vpc.hi-vpc.id
}

# Create EIP
resource "aws_eip" "nat_ip" {
    vpc = true
    
    lifecycle {
        create_before_destroy = true
    }
}

# Create Nat Gateway

resource "aws_nat_gateway" "hi-nat" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id = aws_subnet.hi-public-subnet-2a.id

    tags = {
        Name = "hi-nat"
    }
}

# Create Route Table
## Create Public Route Table

resource "aws_route_table" "hi-public-rtb" {
    vpc_id = aws_vpc.hi-vpc.id

    tags = {
        Name = "hi-public-rtb"
    }
}

## Create Private Route Table
resource "aws_route_table" "hi-private-rtb" {
    vpc_id = aws_vpc.hi-vpc.id

    tags = {
        Name = "hi-private-rtb"
    }
}

# Subnet Register RTB
## Public Subnet Register RTB

resource "aws_route_table_association" "hi-public-rt-association-1" {
    subnet_id = aws_subnet.hi-public-subnet-2a.id
    route_table_id = aws_route_table.hi-public-rtb.id
}

## Private Subnet Register RTB 
resource "aws_route_table_association" "hi-private-rt-association-1" {
    subnet_id = aws_subnet.hi-private-subnet-2a.id
    route_table_id = aws_route_table.hi-private-rtb.id
}

## Internet Gateway Register RTB
resource "aws_route" "public-rt-igw" {
    route_table_id = aws_route_table.hi-public-rtb.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hi-igw.id
}

## Nat Register RTB
resource "aws_route" "private-rt-nat" {
    route_table_id = aws_route_table.hi-private-rtb.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hi-nat.id
}