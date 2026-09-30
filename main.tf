locals {
  local_tags = {
    Name = var.name
  }

  tags = merge(
    var.tags,
    local.local_tags
  )
}

resource "aws_security_group" "lb_sg" {
  name   = var.name
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "lb_sg_ingress_80" {
  count = var.http_enabled ? 1 : 0

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.ip_allowlist
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb_sg_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.ip_allowlist
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_lb" "lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.lb_sg.id,
  ]

  subnets = var.subnet_ids
  tags    = local.tags
}

resource "aws_lb_target_group" "lb_tg_http" {
  name_prefix = "http-"
  vpc_id      = var.vpc_id
  port        = var.egress_port
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
    matcher  = var.matcher
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "lb_listener_http" {
  count = var.http_enabled ? 1 : 0

  load_balancer_arn = aws_lb.lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_tg_http.id
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "lb_listener_https" {
  count = var.ssl_certificate_enabled ? 1 : 0

  load_balancer_arn = aws_lb.lb.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.ssl_certificate_arn
  ssl_policy        = var.ssl_policy

  default_action {
    target_group_arn = aws_lb_target_group.lb_tg_http.id
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}
