variable "cluster_name" {
    default = "k8s-srechallenge"
}

variable "aws_region" {
    default = "us-east-1"
}

variable "vpc_configuration" {
  type = object({
    cidr_block = string
    subnets = list(object({
      name       = string
      cidr_block = string
      public     = bool
    }))
  })
}

variable "k8s_version" {
  type        = string
}

variable "node_instance_size" {
  default = [
    "t2.micro"
  ]
}

variable "auto_scale_options" {
  default = {
    min     = 1
    max     = 2
    desired = 1
  }
}