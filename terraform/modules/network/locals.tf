locals {
    private_subnets = sort([ for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == false ])
    public_subnets = sort([ for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == true ])
    avzo = sort(slice(data.aws_availability_zones.available.zone_ids, 0, length(local.private_subnets)))
    subnet_pairs = zipmap(local.private_subnets, local.public_subnets)
    az_pairs = merge(
        zipmap(local.private_subnets, local.avzo),
        zipmap(local.public_subnets, local.avzo)
    )
}