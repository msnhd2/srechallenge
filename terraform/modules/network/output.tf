output "cluster_vpc" {
    value = aws_vpc.this
}

output "subnets_public" {
    value = {for_each = toset(local.public_subnets)}
}

output "subnets_private" {
    value = {for_each = toset(local.private_subnets)}
}