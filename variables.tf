# Defining the region
variable "region" {
  default = "eu-west-2"
}

# Defining CIDR Block for VPC
variable "vpc_id" {
  default = "10.0.0.0/20"
}

# Defining the instance type
variable "instance_type" {
  default = "t2.micro"
}

# Defining Key Name for connection
variable "key_name" {
  default     = "cba-web-KP"
  description = "Name of AWS Keypair"
}
# Defining CIDR Block for public subnet
variable "subnet1_cidr" {
  default = "10.0.1.0/24"
}

# Defining the ami
variable "instance_ami" {
  default = "ami-0ad97c80f2dfe623b"

}