terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "sg_8080" {
  name = "terraform-learn-state-sg-8080"
  description = "Allow inbound traffic to Python API from VPC CIDR"
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Allow all inbound traffic on port 8080"
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP outbound for package updates"
  }
  
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound for secure package updates"
  }
  
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow DNS outbound for name resolution"
  }
}

resource "aws_instance" "devops_journey_ec2" {
    ami = data.aws_ami.ubuntu.id # Example AMI, replace with a valid one for your region
    instance_type = var.instance_type
    monitoring = true
    ebs_optimized = true
    vpc_security_group_ids = [aws_security_group.sg_8080.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

    # Configure encrypted root volume
    root_block_device {
      volume_size = 20
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
    }

    # Disable IMDSv1 and require IMDSv2
    metadata_options {
      http_endpoint = "enabled"
      http_tokens   = "required"
      http_put_response_hop_limit = 1
    }

    tags = {
      Name = var.instance_name
      Environment = "development"
    }
}

# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "devops-journey-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "devops-journey-ec2-role"
    Environment = "development"
  }
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "devops-journey-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Attach basic policies to the role
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Get the default EBS encryption key
data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}