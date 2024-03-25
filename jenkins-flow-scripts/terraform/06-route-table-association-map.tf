
resource "aws_route_table_association" "rout_custom_association" {
  route_table_id = aws_route_table.custom_rout_table.id
  subnet_id      = aws_subnet.public_subnet.id
}
