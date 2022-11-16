# resource "aws_key_pair" "k8s-key" {
#   # Definição de variaveis confidenciais para garantir segurança: https://learn.hashicorp.com/tutorials/terraform/sensitive-variables?in=terraform/0-14
#   key_name = "k8s-key"
#   public_key = file("./${path.module}/public_key.pub")
#    # Option 2: public_key = var.public_key nesta opção deve-se utilizar um arquivo tfvars para passar a chave ssh
# }

resource "aws_vpc" "this" { # Convenção de nome this quando só tem tem um resource do mesmo tipo em um arquivo
  cidr_block = var.vpc_configuration.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
      Name = format("vpc-%s", var.cluster_name)
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = format("internet-gateway-%s", var.cluster_name)
  }
}

resource "aws_subnet" "this" {
# Para não criar vários resources para cada subnet utilizei o parâmetro for_each que esta disponivel
# a partir do terraform 12, e ele irá criar uma subnet para cada objeto da lista ou map
  for_each = { for subnet in var.vpc_configuration.subnets: subnet.name => subnet}
# Colocar o id da availability zone hard coded não é uma boa prática pois pode ser alterado com o passar do tempo.
# Criei um data para buscar as availability zones disponiveis na região que utilizamos na aws.
  availability_zone_id = local.az_pairs[each.key] #each.key buscar o subnet.name
  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr_block #each.value pega algum valor de dentro do bloco criado em variables
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = format("%s-%s", var.cluster_name, each.key)
  }
}

resource "aws_eip" "nat_gateway" {
  for_each = toset(local.private_subnets)
  vpc = true
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  for_each = toset(local.private_subnets)

  allocation_id = aws_eip.nat_gateway[each.value].id
# Garanti que o Nat gateway esteja na avaiability zone e subnet publica correta para a respectiva subnet privada utilizar
  subnet_id = aws_subnet.this[local.subnet_pairs[each.value]].id
}

# Rotas públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "internet_gateway" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
# Foi utilizada a função toset com o objetivo de remover itens duplicados na lista passada como parametro, e descartar a ordenação.
# Documentação toset(https://www.terraform.io/language/functions/toset)
  for_each = toset(local.public_subnets) 
  subnet_id = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.public.id
}

# Rotas privadas
resource "aws_route_table" "private" {
  for_each = toset(local.private_subnets)
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "nat_gateway" {
  for_each = toset(local.private_subnets)
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.private[each.value].id
  nat_gateway_id = aws_nat_gateway.this[each.value].id
}

resource "aws_route_table_association" "private" {
  for_each = toset(local.private_subnets)
  subnet_id = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}