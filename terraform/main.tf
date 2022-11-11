module "vpc" {
    source = "./modules/network"
    vpc_configuration = var.vpc_configuration
    cluster_name = var.cluster
    aws_region = var.aws_region
}