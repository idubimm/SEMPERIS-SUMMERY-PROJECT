provider "aws" {
    region = "us-east-1"
    access_key = "AKIAUPJHLAH4IH6Y7YBQ"
    secret_key = "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"
}

resource "aws_instance" "my-ubuntu-t2-micro" {
    ami = "ami-07d9b9ddc6cd8dd30"
    instance_type = "t2.micro"
    tags = {
      Name="kuku"
    }
}

resource "aws_eip" "example" {
    domain="vpc"  
}

resource "aws_eip_association" "aip_assoc" {
    instance_id = aws_instance.my-ubuntu-t2-micro.id  
    allocation_id = aws_eip.example.id
}


output "public_ip" {
    value = aws_instance.my-ubuntu-t2-micro.public_ip
}

# terraform plan -target="aws_instance.my-ubuntu-t2-micro"
# it is convention protocole to  use this for 
# resources : main.tf 
# variables : terraform.tfvars 