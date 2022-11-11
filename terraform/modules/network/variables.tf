variable "vpc_configuration" {
    type = object({
        cidr_block = string
        subnets = list(object({
        name = string
        cidr_block = string
        public = bool
        }))
    })
}