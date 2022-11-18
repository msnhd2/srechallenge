output "cluster_vpc" {
    value = aws_vpc.this
}

output "subnets" {
    value = aws_subnet.this
}

output "cluster_vpc_id" {
    value = aws_vpc.this.id
}

output "public_subnets" {
    value = {for_each = toset(local.public_subnets)}
}

output "private_subnets" {
    value = {for_each = toset(local.private_subnets)}
}

output "aws_security_group" {
    value = aws_security_group.cluster_master_sg.id
}