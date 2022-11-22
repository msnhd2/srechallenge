resource "aws_eks_node_group" "cluster" {
  cluster_name = var.eks_cluster.name
  node_group_name =  format("%s-node-group", var.cluster_name)
  node_role_arn = var.eks_nodes_roles_arn

  subnet_ids = [
    var.private_subnets_a.id,
    var.private_subnets_b.id
  ]

  instance_types = var.node_instance_size

  scaling_config {
    desired_size = lookup(var.auto_scale_options, "desired")
    max_size     = lookup(var.auto_scale_options, "max")
    min_size     = lookup(var.auto_scale_options, "min")
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}