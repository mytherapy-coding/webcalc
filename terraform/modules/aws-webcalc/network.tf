# Create VPC with public and private subnets
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define Internet Gateway (IGW) attached to VPC
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Specify the desired AZ
  # Specify dependency on the VPC and IGW
  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a" # Specify the desired AZ
}


# Create security group allowing outbound HTTPS to DockerHub
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  description = "Allow outbound traffic to DockerHub"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

