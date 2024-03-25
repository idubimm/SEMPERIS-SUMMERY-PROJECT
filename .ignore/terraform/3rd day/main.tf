resource "aws_instance" "ec2-client" {
    count = 3
    ami           = "ami-123456" # Replace with a valid AMI for your region
    instance_type = "t2.micro" # Specify the instance type

    tags = {
        Name = "web-server-${count.index}" # Unique name for each instance
    }

    lifecycle {
        create_before_destroy = true
    }
}