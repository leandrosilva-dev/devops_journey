variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "us-east-2"
}

variable "instance_name" {
    description = "Devops Journey EC2 instance"
    type        = string
    default     = "my-ec2-instance"
}

variable "instance_type" {
    description = "Type of the EC2 instance"
    type        = string
    default     = "t2.micro"
}