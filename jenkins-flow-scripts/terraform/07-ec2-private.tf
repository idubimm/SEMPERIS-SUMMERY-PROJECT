

resource "aws_instance" "ec2-custom-private-compute" {
  ami                    = var.image_ids_free_tier["ubuntu_srv_2204"]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_custom_private.id]
  key_name               = var.custom_key_pair
  tags = {
    "Name"        = "ec2-custom-private-compute"
    "description" = "the ec2 in private subnet"
  }
}
