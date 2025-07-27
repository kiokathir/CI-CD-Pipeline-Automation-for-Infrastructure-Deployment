provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "Infra_vpc"{
    cidr_block ="10.0.0.0/16"
    enable_dns_support=true
    enable_dns_hostnames=true
    tags ={
        Name = "Infra_vpc"
    }
}
resource "aws_internet_gateway" "Internet_gateway"{
    vpc_id=aws_vpc.Infra_vpc.id
    tags={
        Name = "IGW"
    }
}

resource "aws_subnet" "public_subnet"{
    vpc_id=aws_vpc.Infra_vpc.id
    cidr_block="10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone="ap-south-1a"
    tags{
        Name = "Pub-Sub"
    }
}

resource "aws_subnet" "private_subnet"{
    vpc_id=aws_vpc.Infra_vpc.id
    cidr_block="10.0.2.0/24"
    availability_zone="ap-south-1a"
    tags{
        Name = "Pri-Sub"
    }
}

resource "aws_route_table" "public_route_table"{
    vpc_id=aws_vpc.Infra_vpc.id
    route{
        gateway_id=aws_internet_gateway.Internet_gateway.id
        cidr_block="0.0.0.0/0"
    }
    tags ={
        Name = "Public-RT"
    }
}

resource "aws_route_table_association" "Public_RT_association"{
    subnet_id=aws_subnet.public_subnet.id
    route_table_id=aws_route_table.public_route_table.id
}

resource "aws_eip" "Nat"{
    vpc = true
}

resource "aws_nat_gateway" "Nat_gateway"{
    allocation_id = aws_eip.Nat.id 
    subnet_id=aws_subnet.public_subnet.id
     tags={
        Name = "Nat"
    }
    depends_on = [aws_internet_gateway.Internet_gateway]
}

resource "aws_route_table" "private_route_table"{
    vpc_id=aws_vpc.Infra_vpc.id
    route{
        gateway_id=aws_nat_gateway.Nat_gateway.id
        cidr_block="0.0.0.0/0"
    }
    tags ={
        Name = "Private-RT"
    }
}

resource "aws_route_table_association" "Private_RT_association"{
    subnet_id=aws_subnet.private_subnet.id
    route_table_id=aws_route_table.private_route_table.id
}

resource "aws_security_group" "public-sg"{
    name="public-sg"
    description="Allow ssh and https"
    vpc_id=aws_vpc.Infra_vpc.id
    ingress{
        description="allow ssh"
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    ingress{
        description = "allow http"
        from_port=80
        to_port=80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        description="allow all outbound traffic"
        from_port=0
        to_port=0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private-sg"{
    name="private-sg"
    description="Allow ssh"
    vpc_id=aws_vpc.Infra_vpc.id
    ingress{
        description="allow ssh"
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks=["10.0.1.0/24"]
    }
    egress{
        description="allow all outbound traffic"
        from_port=0
        to_port=0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "Public_ec2"{
    ami="ami-0d03cb826412c6b0f"
    instance_type="t2.micro"
    subnet_id=aws_subnet.public_subnet.id
    security_groups=[aws_security_group.public-sg.name]
     associate_public_ip_address = true
    tags={
        Name = "Public-EC2"
    }
}

resource "aws_instance" "Private_ec2"{
    ami="ami-0d03cb826412c6b0f"
    instance_type="t2.micro"
    subnet_id=aws_subnet.private_subnet.id
    security_groups=[aws_security_group.private-sg.name]
    tags={
        Name = "Private-EC2"
    }
    depends_on = [aws_nat_gateway.Nat_gateway]
}
