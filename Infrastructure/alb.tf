resource "aws_alb" "checkout" {
  name = "${var.application_name}-${var.environment}"

  # launch lbs in public or private subnets based on "internal" variable
  internal = var.internal
  load_balancer_type = var.load_balancer_type
  subnets = [module.vpc.public_subnets]
  security_groups = [aws_security_group.nsg_lb.id]
  tags            = var.tags

  # enable access logs in order to get support from aws
  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.lb_access_logs.bucket
  }
}

resource "aws_alb_target_group" "checkout" {
  name                 = "${var.application_name}-${var.environment}"
  port                 = var.lb_port
  protocol             = var.lb_protocol
  vpc_id               = module.vpc.vpc_id
  target_type          = "ip"

  health_check {
    enabled             = var.enabled
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = var.tags
}