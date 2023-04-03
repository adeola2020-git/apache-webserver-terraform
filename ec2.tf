# Declare the VPC region
provider "aws" {
  region = var.region
}

# Create a custom VPC
resource "aws_vpc" "terra-VPC" {
  cidr_block           = var.vpc_id
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    "Name" = "web-access-VPC"
  }
}

# Create the Public Subnet
resource "aws_subnet" "terraform_public_subnet" {
  vpc_id                  = aws_vpc.terra-VPC.id
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    "Name" = "10.0.1.0/24-public-subnet"
  }
}

# Create the IGW

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terra-VPC.id
  tags = {
    "Name" = "terraform_igw"
  }
}

# Create a route to the internet makking the IGW the target
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.terra-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
  tags = {
    "Name" = "Route to the internet"
  }
}

# Associate the public subnet to the route table for public access
resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.route.id
}

# Create a security group to allow public access 
resource "aws_security_group" "Terra_SG" {
  name        = "Terra_SG"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.terra-VPC.id
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ssh access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound Rules - Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "web_access_SG"
  }
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "Terra_instance" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.terraform_public_subnet.id
  security_groups = [aws_security_group.Terra_SG.id]
  key_name        = var.key_name
  user_data       = "${file("user-data.sh")}" 
  tags = {
    "Name" = "web_access"
  }
}

output "instance_public_ip" {
  value = aws_instance.Terra_instance.public_ip

}