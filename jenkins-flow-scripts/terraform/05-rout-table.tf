resource "aws_route_table" "custom_rout_table" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    # anitihn that comes in will go throught the gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_custom.id
  }

  tags = {
    "Name"        = "rt_custom_internet"
    "Description" = "route table - to control all of the internet incoming - 1 level of control over the incoming  "
  }

}
