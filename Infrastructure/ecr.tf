data "aws_ecr_repository" "hello-app"{

  name = var.ecr_repository_name
}