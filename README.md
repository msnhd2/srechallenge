# SRE Challenge | Python API

## Descrição do Projeto

Este projeto consiste em uma API que torna possível cadastrar, consulta de usuários.

As pipelines de integração continua e continua são feitas no Jenkins.

A API fica hospedada em um eks.

Foi utilizado o terraform como IaC para provisionamento do ambiente na AWS.

URLs de acesso:

- EKS - URL

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

### Provisionar serviços com terraform

 Neste projeto foi utilizado o terraform para provisionar o cluster kubernetes.
 
 :arrow_forward: EKS

## Deploy

Caminho a produção: trunk base development
 Temos apenas 1 branch fixa no projeto: Main.
 O restante das branchs são feature branchs

 ### EKS

 Quando for efetuado o merge do PR o CI do Jenkins irá:
 - Efetuar o build da imagem docker
 - Realizar o upload da nova imagem docker para o registry
 - Executar testes unitários

 ## Desenvolvedor

 Rodrigo Andrade Mendonça de Oliveira