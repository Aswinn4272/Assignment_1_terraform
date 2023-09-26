provider "aws" {
  region  = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id # creating public subnet in my vpc
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "ap-south-1a" 
  map_public_ip_on_launch = true
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id # creating private subnet in my vpc
  cidr_block              = "10.0.2.0/24" 
  availability_zone       = "ap-south-1b" 
}

# Create a security group for EC2 instance
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id

  # Inbound rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Outbound rule for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0f5ee92e2d63afc18"   # ami id
  instance_type = "t2.micro"
subnet_id     = aws_subnet.public_subnet.id    # creating instance in the public subnet 
vpc_security_group_ids = [aws_security_group.my_security_group.id]    # attaching security group with this EC2 instance

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    purpose = "Assignment"    # tag as key should be "purpose" and value should be "Assignment"
  }
}


