resource "aws_eks_cluster" "eks_cluster" {
    name    = var.cluster_name
    version = var.k8s_version
    role_arn = var.eks_cluster_role_arn
    #count = length(var.private_subnets)
    vpc_config {

        security_group_ids = [
            var.aws_security_group
        ]

        subnet_ids = [var.private_subnets_a.id,
                      var.private_subnets_b.id]
        
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}