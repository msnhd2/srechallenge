output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_nodes_roles_arn" {
  value = aws_iam_role.eks_nodes_roles.arn
}