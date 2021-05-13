resource "aws_ecs_cluster" "checkout" {
  name = "${var.application_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}