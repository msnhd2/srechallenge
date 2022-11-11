terraform {
  # Se não for definido o escopo da versão do provedor adequadamente, o Terraform baixará a versão mais recente do provedor que atende à restrição de versão.
  # Isso pode levar a alterações inesperadas na infraestrutura. Ao especificar cuidadosamente as versões do provedor e usar o arquivo de bloqueio de dependência,
  # pode-se garantir que o Terraform esteja usando a versão correta do provedor para que sua configuração seja aplicada de forma consistente.
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}