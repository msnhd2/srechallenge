variable "cluster" {
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

variable "service_name" {
  type        = string
  description = ""
}

variable "service_domain" {
  type        = string
  description = ""
}