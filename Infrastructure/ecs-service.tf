resource "aws_ecs_service" "checkout" {
  name            = "${var.application_name}-${var.environment}"
  cluster         = aws_ecs_cluster.checkout.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.checkout.arn
  desired_count   = var.desired_count

  network_configuration {
    security_groups = [aws_security_group.nsg_task.id]
    subnets         = [module.vpc.public_subnets]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.checkout.id
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags                    = var.tags
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"


  lifecycle {
    ignore_changes = [task_definition]
  }
}
