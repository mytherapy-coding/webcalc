# Define the ALB
resource "aws_lb" "webcalc_alb" {
  name               = "webcalc-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_b.id
  ]
  security_groups = [aws_security_group.ecs_security_group.id]

  enable_http2 = true

  tags = {
    Name = "webcalc-alb"
  }
}

# Define ALB target group
resource "aws_lb_target_group" "webcalc_target_group" {
  name     = "webcalc-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/api/health" # Update health check path
    port                = 80
    protocol            = "HTTP"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
    matcher             = "200"
  }
}

# Define ALB listener
resource "aws_lb_listener" "webcalc_listener" {
  load_balancer_arn = aws_lb.webcalc_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webcalc_target_group.arn
  }
}

