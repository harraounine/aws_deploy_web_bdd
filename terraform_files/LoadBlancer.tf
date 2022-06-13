########################## HIGHT AVAILABILITY ############################ 


# Add the ELB for Load Balancing

resource "aws_lb" "lbrole" {
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  idle_timeout       = 120

  subnets         = [aws_subnet.my_app-subnet[0].id, aws_subnet.my_app-subnet[1].id]
  security_groups = [aws_security_group.LB.id]

  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_lb_listener" "lisnter" {
  load_balancer_arn = aws_lb.lbrole.arn
  port              = var.ports[2]
  protocol          = "HTTP"
  lifecycle {
    create_before_destroy = true

  }
  default_action {
    target_group_arn = aws_lb_target_group.mytargets.arn
    type             = "forward"
  }

}
resource "aws_lb_listener_rule" "rule1" {
  listener_arn = aws_lb_listener.lisnter.arn
  condition {
    http_request_method {
      values = ["GET", "HEAD"]
    }
  }
  action {
    target_group_arn = aws_lb_target_group.mytargets.arn
    type             = "forward"

  }
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_target_group" "mytargets" {
  load_balancing_algorithm_type = "round_robin"
  lifecycle {
    create_before_destroy = true
  }
  vpc_id      = aws_vpc.my_vpc.id
  port        = var.ports[2]
  protocol    = "HTTP"
  target_type = "instance"
  health_check {
    port                = var.ports[2]
    protocol            = "HTTP"
    path                = "/"
    interval            = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
  }
}
