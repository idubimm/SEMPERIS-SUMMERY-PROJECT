

image_ids_free_tier = {
  aws_2023                 = "ami-0c101f26f147fa7fd"
  aws_linux2               = "ami-02d7fd1c2af6eead0"
  redhut_linux9            = "ami-0fe630eb857a6ec83"
  ubuntu_srv_2204          = "ami-080e1f13689e07408"
  ubuntu_srv_2004          = "ami-0cd59ecaf368e5ccf"
  debian_12                = "ami-058bd2d568351da34"
  aws_linux2_net6_ps7_mono = "ami-02aead0a55359d6ec"
}

sg_ingress_ports = [80, 22, 5000, 6443]

custom_key_pair = "semperis-exercise-kp"

subnets_availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]

