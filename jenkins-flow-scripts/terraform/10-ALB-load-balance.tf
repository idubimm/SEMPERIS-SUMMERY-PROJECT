
resource "aws_lb" "custom_lb" {
  name               = "custom-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_custom.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_e.id]


  tags = {
    Name = "my-lb"
  }
}

resource "aws_lb_target_group" "custom_lb_target_group" {
  name     = "custom-loadbalance-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
  }
}

resource "aws_lb_listener" "custom_lb_listener" {
  load_balancer_arn = aws_lb.custom_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.custom_lb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "custom-lb-target-group-attachement" {
  for_each = { for idx, inst in aws_instance.ec2-custom-public-compute : tostring(idx) => inst.id }

  target_group_arn = aws_lb_target_group.custom_lb_target_group.arn
  target_id        = each.value
  port             = 80
}


