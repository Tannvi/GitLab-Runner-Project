terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
}

# Provider configuration
provider "aws" {
  region = "eu-west-2"  # Change to your desired region
  access_key = "var.aws_access_key"  # Referencing variable
  secret_key = "var.aws_secret_key"  # Referencing variable
}


// To Generate Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}


# VPC configuration
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "GitLab Runner VPC"
  }
}

# Internet Gateway for internet access
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "GitLab Runner Internet Gateway"
  }
}

# Route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"    # Route all traffic to the internet
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Public Subnet configuration
resource "aws_subnet" "gitlab_runner_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"  # Change to your desired availability zone
  map_public_ip_on_launch = true  # Automatically assign public IP to instances

  tags = {
    Name = "GitLab Runner Public Subnet"
  }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.gitlab_runner_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security group to allow SSH and other necessary traffic
resource "aws_security_group" "gitlab_runner_sg" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (modify as needed)
  }

  ingress {
    from_port   = 80      # Allow HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443     # Allow HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "GitLab Runner Security Group"
  }
}
#Create Network Interface

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.gitlab_runner_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.gitlab_runner_sg.id]

  }

  #Create Elastic IP

  resource "aws_eip" "one" {
  network_interface = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.main_igw]
  }


# EC2 instance for GitLab Runner
resource "aws_instance" "gitlab_runner" {
  ami                    = "ami-0683ac74b28130646"  # Amazon Linux 2023 ARM64 AMI
  instance_type          = "m6g.xlarge"  # Graviton2 instance type
  subnet_id              = aws_subnet.gitlab_runner_subnet.id
  vpc_security_group_ids = [aws_security_group.gitlab_runner_sg.id]
  associate_public_ip_address = true  # Ensure public IP is assigned
  key_name = "runner-key"

  root_block_device {
    volume_size = 20  # Root volume size (20GB)
    volume_type = "gp3"  # General Purpose SSD (GP3)
  }

  user_data = <<-EOF
           #!/bin/bash
           yum update -y
           yum install -y curl
           curl -L --output gitlab-runner.deb https://gitlab-runner-downloads.s3.amazonaws.com/latest/debian/gitlab-runner_arm64.deb
           rpm -i gitlab-runner.deb
           gitlab-runner install
           gitlab-runner start
           EOF

  tags = {
    Name = "GitLab Runner m6g Instance"
  }
}
