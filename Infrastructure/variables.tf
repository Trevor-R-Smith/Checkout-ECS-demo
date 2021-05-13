variable "application_name" {
  type = string
  description = "The name of the application that is being deployed"
}

variable "environment" {
  type = string
  description = "The name of the environment being deployed inot"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 90
  description = "Specifies the number of days you want to retain log events"
}

variable "region" {}

variable "ecr_repository_name" {
  type = string
  description = "Name of the repository"
}

##############
# ECS
#############

variable "desired_count" {
  type = number
  description = "The number of replicas"
  default = 3
}

variable "container_name" {
  type = string
  description = "The container port name"
  default = "checkout"
}

variable "container_port" {
  type = number
  description = "The container port number"
  default = 8080
}

##############
# ALB
##############

variable "internal" {
  type = bool
  description = "If the Alb is a public or a private"
  default = false
}

variable "load_balancer_type" {
  type = string
  description = "The type of load balance being deployed"
  default = "application"
}

variable "lb_port" {
  type = number
  description = "The load balancer port number"
  default = 80
}

variable "lb_protocol" {
  type = string
  description = "The load balance protocol to be used"
  default = "HTTP"
}

variable "enabled" {
  type = bool
  description = "Whether the health check is enabled or disabled"
  default = true
}

variable "health_check_matcher" {
  type = string
  description = "Response codes to use when checking for a healthy responses from a target."
  default = "200-299"

}
variable "health_check_interval"{
  type = number
  description = "pproximate amount of time, in seconds, between health checks of an individual target"
  default = 300

}
variable "health_check_timeout"{
  type = number
  description = "Amount of time, in seconds, during which no response means a failed health check"
  default = 5

}

################
# TAGS
################

variable "tags" {
  type = map
  description = "The tags to be added to resources"
  default = {
    "department": "department",
    "team": "team",
    "app": "application",
    "env": "environment"
  }
}