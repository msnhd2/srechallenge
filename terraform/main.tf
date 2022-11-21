module "vpc" {
    source            = "./modules/network"
    vpc_configuration = var.vpc_configuration
    cluster_name      = var.cluster_name
}

module "iam" {
    source      = "./modules/iam"
    cluster_name    = var.cluster_name
}

module "eks" {
    source          = "./modules/eks"
    cluster_name    = var.cluster_name
    aws_region      = var.aws_region
    k8s_version     = var.k8s_version
    cluster_vpc     = module.vpc.cluster_vpc
    cluster_vpc_id  = module.vpc.cluster_vpc_id
    eks_cluster_role_arn = module.iam.eks_cluster_role_arn
    private_subnets_a = module.vpc.subnets_a
    private_subnets_b = module.vpc.subnets_b
    aws_security_group = module.vpc.aws_security_group

    depends_on = [module.vpc, module.iam]
}