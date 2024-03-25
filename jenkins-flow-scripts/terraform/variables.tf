

variable "image_ids_free_tier" {
  description = "List of AMI IDs in free tier"
  type        = map(string)
}


variable "sg_ingress_ports" {
  description = "available ports to be reffered in security groups"
  type        = list(number)
}

variable "custom_key_pair" {
  description = "key pair pre created for this excersize to be used by jenkins to connect ssh to all my ec2 instances"
  type        = string
}
