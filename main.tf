# main.tf

provider "aws" {
  region = "us-west-2" # Change to your desired region
}

# S3 bucket resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = "loyalist-s3-bucket-1"
  acl    = "private"
  tags = {
    Project      = "CLOD1003"
    "Created by" = "ROHIT LOYALIST"
  }
}

# IAM user with full permission to S3 bucket
resource "aws_iam_user" "s3_full_access_user" {
  name = "s3-full-access-user"
  tags = {
    Project      = "CLOD1003"
    "Created by" = "ROHIT LOYALIST"
  }
}

resource "aws_iam_user_policy_attachment" "s3_full_access_policy_attachment" {
  user       = aws_iam_user.s3_full_access_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  name        = "instance-security-group"
  description = "Security group for EC2 instances"
  tags = {
    Project      = "CLOD1003"
    "Created by" = "ROHIT LOYALIST"
  }

  ingress {
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance resource
resource "aws_instance" "example_instance" {
  count         = 2
  ami           = "ami-093467ec28ae4fe03" # Replace with your AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance_sg.name]
  tags = {
    Project      = "CLOD1003"
    "Created by" = "ROHIT LOYALIST"
  }
}

# Output the S3 bucket name and IAM user details
output "s3_bucket_name" {
  value = aws_s3_bucket.example_bucket.id
}

output "iam_user_details" {
  value = aws_iam_user.s3_full_access_user
}

