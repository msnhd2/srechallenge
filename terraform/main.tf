module "vpc" {
    source = "./modules/network"
    vpc_configuration = var.vpc_configuration
    cluster_name  = var.cluster_name
}

# module "eks" {
#     source = "./modules/eks"
#     cluster_name    = var.cluster_name
#     aws_region      = var.aws_region
#     k8s_version     = var.k8s_version
#     cluster_vpc     = module.network.cluster_vpc
#     private_subnets = module.network.subnets_private

# }