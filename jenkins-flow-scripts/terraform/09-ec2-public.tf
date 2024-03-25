
resource "aws_instance" "ec2-custom-public-compute" {
  count                  = 2
  ami                    = var.image_ids_free_tier["ubuntu_srv_2204"]
  instance_type          = "t2.micro"
  subnet_id              = (count.index + 1) % 2 == 1 ? aws_subnet.public_subnet_a.id : aws_subnet.public_subnet_e.id
  vpc_security_group_ids = [aws_security_group.sg_custom.id]
  key_name               = var.custom_key_pair

  # user_data = <<-EOF
  #     #!/bin/bash
  #     echo "Installing dependencies..."
  #     sudo apt-get update
  #     sudo apt-get install -y docker.io
  #     sudo systemctl start docker
  #     echo "Pulling and running Docker container..."
  #     sudo  pull lilachamar/flask-sql-i:latest
  #     sudo docker run -d -p 5000:5000 lilachamar/flask-sql-i:latest
  # EOF

  tags = {
    "Name"        = "ec2-custom-public-compute-${count.index + 1}"
    "description" = "the ec2 instance that will be created for purposes of control plan fon k8 constallation"
  }
}
