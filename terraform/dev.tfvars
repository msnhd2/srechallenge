service_name   = "SreChallenge"
service_domain = "api-srechallenge"
vpc_configuration = {
  cidr_block = "10.0.0.0/16"
  subnets = [
    {
      name       = "private-a"
      public     = false
      cidr_block = "10.0.0.0/19"
    },
    {
      name       = "private-b"
      public     = false
      cidr_block = "10.0.32.0/19"
    },
    {
      name       = "public-a"
      public     = true
      cidr_block = "10.0.160.0/19"
    },
    {
      name       = "public-b"
      public     = true
      cidr_block = "10.0.192.0/19"
    }
  ]
}
