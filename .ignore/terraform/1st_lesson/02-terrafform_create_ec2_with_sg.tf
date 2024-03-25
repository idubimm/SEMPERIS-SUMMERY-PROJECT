resource "aws_instance" "ec2_for_sg_2" {
    ami = "ami-07d9b9ddc6cd8dd30"
    instance_type = "t2.micro"
    key_name      = "r53-ex" # The name of the SSH key pair

    security_groups = [aws_security_group.terraform_sg.name]

    tags = {
      Name = "ExampleInstance"
    }
}