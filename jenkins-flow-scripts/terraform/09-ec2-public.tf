
resource "aws_instance" "ec2_custom_public_compute_a" {
  ami                    = var.image_ids_free_tier["ubuntu_srv_2204"]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  vpc_security_group_ids = [aws_security_group.sg_custom_public.id]
  key_name               = var.custom_key_pair

  user_data = <<-EOF
    #!/bin/bash
    echo "Installing docker and compose..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo apt-get install -y docker-compose
    echo "pulling docker compose images "
    wget "https://raw.githubusercontent.com/idubimm/SEMPERIS-SUMMERY-PROJECT/main/src/docker-compose-flat-withoutparamters.yml" ./docker-compose-image.yml
    sudo docker-compose -f ./docker-compose-flat-withoutparamters.yml  up
EOF

  tags = {
    "Name"        = "ec2_custom_public_compute_a"
    "description" = "the ec2 instance that will be created for purposes of control plan fon k8 constallation"
  }
}
resource "aws_instance" "ec2_custom_public_compute_e" {
  ami                    = var.image_ids_free_tier["ubuntu_srv_2204"]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_e.id
  vpc_security_group_ids = [aws_security_group.sg_custom_public.id]
  key_name               = var.custom_key_pair

  user_data = <<-EOF
#!/bin/bash
echo "Installing docker and compose..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo apt-get install -y docker-compose
echo "pulling docker compose images "
wget "https://raw.githubusercontent.com/idubimm/SEMPERIS-SUMMERY-PROJECT/main/src/docker-compose-flat-withoutparamters.yml" ./docker-compose-image.yml
sudo docker-compose -f ./docker-compose-flat-withoutparamters.yml  up
EOF

  tags = {
    "Name"        = "ec2_custom_public_compute_e"
    "description" = "the ec2 instance that will be created for purposes of control plan fon k8 constallation"
  }
}
