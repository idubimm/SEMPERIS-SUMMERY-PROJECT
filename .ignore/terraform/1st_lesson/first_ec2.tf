provider "aws" {
    region = "us-east-1"
    access_key = env.aws.access_key
    secret_key = env.aws.secret_key
}

resource "aws_instance" "my-ubuntu-t2-micro" {
    ami = "ami-07d9b9ddc6cd8dd30"
    instance_type = "t2.micro"
    tags = {
      Name="kuku"
    }
}

output "public_ip" {
    value = aws_instance.my-ubuntu-t2-micro.public_ip
}

# terraform plan -target="aws_instance.my-ubuntu-t2-micro"
# it is convention protocole to  use this for 
# resources : main.tf 
# variables : terraform.tfvars 
