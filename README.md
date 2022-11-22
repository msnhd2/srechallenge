# SRE Challenge | Python API

## Descrição do Projeto

Este projeto consiste em uma API que torna possível gerenciamento de cadastro de usuários.

As pipelines de integração continua e continua são feitas no Jenkins.

A API fica hospedada em um eks.

Foi utilizado o terraform como IaC para provisionamento do ambiente na AWS.

[Documentação da API](https://docs.google.com/document/d/11iMVa0PZWp-1hjGak5RW7J1ey3WyasWJ/edit#)

## Conteúdos
   * [Funcionalidades](#funcionalidades)
   * [Dependências](#dependências)
   * [Como rodar o projeto](#como-rodar-o-projeto)
   * [Deploy](#deploy)

## Funcionalidades

:trophy: Cadastro de usuários
:trophy: Consulta de usuários através do CPF
:trophy: Consulta de todos os usuários
:trophy: Alteração de usuários cadastrados através do cpf
:trophy: Deleção de usuários através do CPF

## Dependências

:arrow_forward: A aplicação utiliza as variáveis cadastradas no arquivo .env

:arrow_forward: Os requisitos abaixo são necessários para executar a criação e provisionamento do ambiente.

- python >= 3.8.5
- docker >= 20.10.7
- terraform >= 0.15.00
- kind >= 0.17.0
- gunicorn >= 20.1.0

## Como rodar o projeto com Docker

:arrow_forward: Build Image

```sh
make build-image
```

:arrow_forward: Subir container com a imagem

```sh
make run-container
```

## Como rodar o projeto com Kubernetes local

:arrow_forward: Criar cluster

```sh
kind create cluster --name sre-challenge
```

:arrow_forward: Build Image

```sh
make build-image
```

:arrow_forward: Apply deployment

```sh
make deploy_api_k8s
```

## Provisionar serviços com terraform

 Neste projeto foi utilizado o terraform para provisionar o cluster kubernetes e todas as suas dependencias(VPC, IAM, worker nodes).

:arrow_forward: Inicialização de modulos terraform

```sh
terraform init
```

:arrow_forward: Planning terraform

```sh
terraform plan -var-file dev.tfvars
```

:arrow_forward: Apply terraform

```sh
terraform apply -var-file dev.tfvars
```

## Deploy

Caminho a produção: trunk base development
 Temos apenas 1 branch fixa no projeto: Main.
 O restante das branchs são feature branchs

 :arrow_forward: Fluxo: feature_branch -> Main

 Quando for efetuado o merge do PR o CI do Jenkins irá:
 - Efetuar o build da imagem docker
 - Executar testes unitários
 - Rodar scan do SonarQube
 - Validar status do QualityGate
 - Realizar o upload da nova imagem docker para o registry

 ## EKS
 - Monitoramento

 <br>:trophy: Grafana</br>
 <br>:trophy: Promotheus</br>

 - Teste de carga
 <br>FortIO</br>

 ## Desenvolvedor

 Rodrigo Andrade Mendonça de Oliveira