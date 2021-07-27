resource "aws_lb" "webapp_alb" {
  name               = "${var.org_name}-${var.app_name}-${var.environment}-webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp_lb_sg.id]
  subnets            = var.pub_subnet_id

  enable_deletion_protection = true

  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_webapp_alb"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

resource "aws_lb_target_group" "webapp_tg" {
  name     = "${var.org_name}-${var.app_name}-${var.environment}-webapp-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    protocol = "HTTPS"
    path     = "/"
  }
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_webapp_tg"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

resource "aws_lb_listener" "webapp_alb_listner" {
  load_balancer_arn = aws_lb.webapp_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.webapp_self_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tg.arn
  }
}

resource "aws_lb_listener" "webapp_alb_listner_80" {
  load_balancer_arn = aws_lb.webapp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}