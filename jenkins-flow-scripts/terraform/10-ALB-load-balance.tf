
resource "aws_lb" "custom_lb" {
  name               = "custom-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_custom_public.id]
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
    target_group_arn = aws_lb_target_group.custom_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "custom_lb_target_group_attachement_a" {
  target_group_arn = aws_lb_target_group.custom_lb_target_group.arn
  target_id        = aws_instance.ec2_custom_public_compute_a.id
  port             = 5000
}

resource "aws_lb_target_group_attachment" "custom_lb_target_group_attachement_e" {
  target_group_arn = aws_lb_target_group.custom_lb_target_group.arn
  target_id        = aws_instance.ec2_custom_public_compute_e.id
  port             = 5000
}

