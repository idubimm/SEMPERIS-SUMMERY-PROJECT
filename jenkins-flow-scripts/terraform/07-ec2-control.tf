

resource "aws_instance" "ec2-control" {
  ami                    = var.image_ids_free_tier["ubuntu_srv_2204"]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_custom.id]
  key_name               = var.custom_key_pair
  tags = {
    "Name"        = "ec2-cotrol"
    "description" = "the ec2 instance that will be created for purposes of control plan fon k8 constallation"
  }
}
