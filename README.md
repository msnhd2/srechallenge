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
- kind >= 0.19.0
- gunicorn >= 20.1.0
- kubernetes EKS >= 1.24
- kubernetes Local >= 1.25.9

## Como rodar o projeto a API localmente

:arrow_forward: Create virtualenv + Install dependencies + running 

```sh
make run-api-local
```

## Como rodar o projeto com Docker

:arrow_forward: Build Image + Running

```sh
make run-api-docker-local
```

## Como rodar o projeto com Kubernetes local

:arrow_forward: Create cluster, namespaces, ArgoCD, Grafana, Prometheus, API, FortIO

```sh
make run-full-deployments-k8s-local
```

## Como testar funcionalidades aplicação manualmente

:arrow_forward: Postman

Importe a configuração do postman localizada em [postman](https://github.com/msnhd2/srechallenge/blob/main/api/postman/SRE-Challenge.postman_collection.json) e utilize a documentação para utilizar a API.


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
 Temos apenas 2 branches fixas no projeto: main e development
 O restante das branchs são feature branchs

 :arrow_forward: Fluxo: feature_branch -> BRANCH developtment(branch onde a release e gerada) -> BRANCH main

 Quando desejar que o codigo novo chegue a produção deve-se efetuar o merge do PR e a pipeline de CD irá:
 - Efetuar o deploy da imagem com a tag latest no registry através do ArgoCD

 Quando o PR for criado o CI do GithubActions irá:
 - Executar o lint
 - Executar testes unitários
 - Rodar scan do SonarCloud
 - Validar status do QualityGate
 - Efetuar o build da imagem docker gerando a tag, e efetuando o push no registry

## EKS

 - #### Estratégia de resiliencia
   <br>:trophy: Auto Scale Cluster</br>
   <br>:trophy: Auto Scale Pods(HPA)</br>

 - #### Monitoramento
   <br>:trophy: Grafana</br>
   <br>:trophy: Promotheus</br>

 - #### IngressController
   <br>:trophy:Nginx</br>

 - #### Teste de carga
   <br>:trophy: FortIO</br>

 - #### Kubernetes Dashboard
   <br>:trophy: Dashboard</br>

## Como fazer um teste de carga

- Com o(s) pod(s) da aplicação rodando execute o seguinte comando:

```sh
make running_fortio
```
Especificação:
  - 800 requisições por segundo
  - Duração de dois minutos
  - 70 conexões simultaneas

Após isso monitore o consumo de recursos pelo grafana, kubernetes-dashboard ou com o comando:

```sh
watch -n1 kubectl get hpa -n srechallenge
```

## Como acessar as ferramentas?

#### Grafana

http://localhost:32000

#### Prometheus Server

http://localhost:8000

#### Dashboard do kubernetes

Após executar o projeto no kubernetes local com o comando (make run-full-deployments-k8s), colete o token que é exibido e acesse o [link](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

 ## Desenvolvedor

 Rodrigo Andrade Mendonça de Oliveira