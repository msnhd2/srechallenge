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
   * [Como rodar o projeto com Docker](#como-rodar-o-projeto-com-docker)
   * [Como rodar o projeto com Kubernetes local](#como-rodar-o-projeto-com-kubernetes-local)
   * [Provisionar serviços com terraform](#provisionar-serviços-com-terraform)
   * [EKS](#eks)
   * [Como fazer um teste de carga](#como-fazer-um-teste-de-carga)
   * [Deploy](#deploy)

## Funcionalidades

<br>:trophy: Cadastro de usuários</br>
<br>:trophy: Consulta de usuários através do CPF</br>
<br>:trophy: Consulta de todos os usuários</br>
<br>:trophy: Alteração de usuários cadastrados através do CPF</br>
<br>:trophy: Deleção de usuários através do CPF</br>

## Dependências

:arrow_forward: A aplicação utiliza as variáveis cadastradas no arquivo .env

:arrow_forward: Os requisitos abaixo são necessários para executar a criação e provisionamento do ambiente.

- python >= 3.8.5
- docker >= 20.10.7
- terraform >= 0.15.00
- kind >= 0.17.0
- gunicorn >= 20.1.0

## Como rodar o projeto a API localmente

:arrow_forward: Create virtualenv + Install dependencies + running 

```sh
make run-api-local
```

## Como rodar o projeto com Docker

:arrow_forward: Build Image

```sh
make run-api-docker-local
```

## Como rodar o projeto com Kubernetes local

:arrow_forward: Create cluster, namespaces + Deploy ArgoCD![image](https://www.google.com/url?sa=i&url=https%3A%2F%2Fcncf-branding.netlify.app%2Fprojects%2Fargo%2F&psig=AOvVaw0NXzUYXHlPMoLnzvsSqvaX&ust=1669901617096000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOia-7eC1vsCFQAAAAAdAAAAABAD), Grafana![alt text](https://www.google.com/url?sa=i&url=https%3A%2F%2Fdocs.mogenius.com%2Fservices%2Fmonitoring%2Fgrafana&psig=AOvVaw2U2w0d1ZPX3ecUJmoV1sou&ust=1669901646992000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCMjMs8aC1vsCFQAAAAAdAAAAABAD), Prometheus![alt text](https://www.google.com/url?sa=i&url=http%3A%2F%2Fwww.stickpng.com%2Fimg%2Ficons-logos-emojis%2Ftech-companies%2Fprometheus-logo&psig=AOvVaw0jJGexh2B05hsjHxmgFIxy&ust=1669901669932000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKCH5dGC1vsCFQAAAAAdAAAAABAD), SonarQube![alt text](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.sonarqube.org%2Flogos%2F&psig=AOvVaw18TPKs_zZ1CbuLdxgSouoV&ust=1669901713992000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCIjP4eeC1vsCFQAAAAAdAAAAABAb) API, FortIO

```sh
make run-full-deployments-k8s
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
 - Gerar Tag

Quando desejar que o codigo novo chegue a produção deve-se executar a pipeline de CD que irá:
 - Checar o status do job de CI
 - Deploy da imagem com a tag latest no registry através do ArgoCD

## EKS

 - #### Estratégia de resiliencia
   <br>:trophy: Auto Scale Cluster</br>
   <br>:trophy: Auto Scale Pods(HPA)</br>

 - #### Monitoramento
   <br>:trophy: Grafana</br>
   <br>:trophy: Promotheus</br>

 - #### IngressController
   <br>Traefik</br>

 - #### Teste de carga
 <br>:trophy: FortIO</br>

## Como fazer um teste de carga

 ## Desenvolvedor

 Rodrigo Andrade Mendonça de Oliveira