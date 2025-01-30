# Specify the Terraform provider for AWS
provider "aws" {
  # region = "eu-central-1" # Change this to your preferred region
  region = "us-east-1" # Change this to your preferred region
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ExampleVPC"
  }
}

# Create an Internet Gateway (IGW)
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "ExampleIGW"
  }
}

# Create a Public Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Assign public IPs automatically
  
  tags = {
    Name = "ExampleSubnet"
  }
}

# Create a Route Table for the Public Subnet
resource "aws_route_table" "example_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id # Route internet traffic to the IGW
  }

  tags = {
    Name = "ExampleRouteTable"
  }
}

# Associate the Route Table with the Subnet (Make it Public)
resource "aws_route_table_association" "example_rta" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_rt.id
}

# Create a Security Group that Allows SSH
resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.example_vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (not recommended for production)
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Generate a new SSH key pair
resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair using the generated public key
resource "aws_key_pair" "example_key_pair" {
  key_name   = "example-key"
  public_key = tls_private_key.example_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key_file" {
  content  = tls_private_key.example_key.private_key_pem
  file_permission = "0600"
  filename = "example-key.pem"
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "example_instance" {
  # ami                          = "ami-00d7be712d19c601f"               # al2023-ami-2023.6.20250123.4-kernel-6.1-x86_64 (eu-central-1 region)
  ami                          = "ami-0ac4dfaf1c5c0cce9"               # al2023-ami-2023.6.20250123.4-kernel-6.1-x86_64 (us-east-1 region)
  instance_type                = "t2.micro"              # Free tier eligible
  subnet_id                    = aws_subnet.example_subnet.id
  vpc_security_group_ids       = [aws_security_group.example_sg.id]
  associate_public_ip_address  = true # Attach a public IP
  key_name                     = aws_key_pair.example_key_pair.key_name # Attach the new key pair
  
  tags = {
    Name = "ExampleInstance"
  }
}
