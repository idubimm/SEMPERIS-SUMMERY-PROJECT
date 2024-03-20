




# provider "aws" {
#     region = "us-east-1"
#     access_key = ""
#     secret_key = "+W3jJ"
# }



resource "aws_security_group" "terraform_sg" {
  name        = "terraform-sg"
  description = "Allow inbound traffic on port 80 and 22 "

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

