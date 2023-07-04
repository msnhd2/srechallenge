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
   * [Como rodar o projeto a API localmente](#como-rodar-o-projeto-da-api-localmente)
   * [Como rodar o projeto com Docker](#como-rodar-o-projeto-com-docker)
   * [Como rodar o projeto com Kubernetes local](#como-rodar-o-projeto-com-kubernetes-local)
   * [Como testar as funcionalidades da aplicação manualmente](#como-testar-as-funcionalidades-da-aplicação-manualmente)
   * [Começando](#começando)
   * [Pre-Requisitos](#pre-requisitos)
   * [Provisionar infraestrutura com terraform pela CLI](#provisionar-infraestrutura-com-terraform-pela-cli)
   * [Provisionar infraestrutura com terraform pela pipeline](#provisionar-serviços-com-terraform-pela-pipeline)
   * [Deploy](#deploy)
   * [EKS](#eks)
   * [Como fazer um teste de carga](#como-fazer-um-teste-de-carga)
   * [Como acessar as ferramentas?](#como-acessar-as-ferramentas)


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
- terraform >= 0.15.0
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

## Como testar as funcionalidades da aplicação manualmente

:arrow_forward: Postman

Importe a configuração do postman localizada em [postman](https://github.com/msnhd2/srechallenge/blob/main/api/postman/SRE-Challenge.postman_collection.json) e utilize a documentação para utilizar a API.

## Começando
```bash
git clone git@github.com:msnhd2/srechallenge.git
cd srechallenge
```
## Pre-Requisitos

#### 1) Instale as ferramentas abaixo para começar com deployments no terraform. Se você estiver usando o Mac OS, execute os comandos abaixo para configurar as ferramentas necessárias.

- Terraform :  brew install terraform 
- AWS CLI (Opcional) : brew install awscli
- TF Lint (Opcional) : brew install tflint
- TfSwitch(Opcional) : brew install warrensbox/tap/tfswitch

#### 2) Para Deployar o código terraform e provisionar a infraestrutura, precisamos de credenciais para conectar com a AWS. Abaixo estão as formas de exportar credenciais.

- Opção-1: Exportando Secret Key and Access Key

 ```bash
  export AWS_ACCESS_KEY_ID="<< SUA ACCESS KEY >>"
  export AWS_SECRET_ACCESS_KEY="<< SUA SECRET ACCESS KEY>>"
 ```

- Opção-2: Use o Profile (Se você acessar AWS através de SSO)
  pre-requisito: Verifique se a AWS CLI está instalada no computador

  ```aws 
   aws configure sso
   SSO start URL [None]: <<sso-start-url da sua conta aws>>
   SSO Region [None]: <<region onde o sso está ativado>>
  ```
  * Selecione a conta com a qual deseja trabalhar
  * Forneça um nome de profile
  * Isso cria uma entrada no arquivo `.aws/config`
  * Exporte o profile `AWS_PROFILE`
    ```bash
      export AWS_PROFILE=((profile_name))
    ```

#### 3) Exportar a Região como variável de ambiente.
```bash
export TF_VAR_region=((REGION_TO_DEPLOY))
```

#### 4) S3 Bucket para armazenar arquivos de estado

Observação: substitua os espaços reservados "BUCKET_NAME" e "REGION_TO_DEPLOY" pelos valores apropriados.

- Configure o S3 Bucket por meio da CLI
```bash
$ aws s3api create-bucket \
--bucket ((BUCKET_NAME))\
--region ((REGION_TO_DEPLOY))\
--create-bucket-configuration LocationConstraint=((REGION_TO_DEPLOY))
```

- Habilite o versionamento
```bash
$ aws s3api put-bucket-versioning --bucket ((BUCKET_NAME)) --versioning-configuration Status=Enabled 
```

- Permissões para configurar o log

  - Atualize o nome do bucket para apontar para o seu bucket no arquivo "logging_bucket_policy.json" (linha nº: 12) presente na raiz do seu repositório.

```bash
$ aws s3api put-bucket-policy --bucket ((BUCKET_NAME))--policy file://logging_bucket_policy.json
```

## Provisionar infraestrutura com terraform pela CLI

 Neste projeto foi utilizado o terraform para provisionar o cluster kubernetes e todas as suas dependencias(VPC, IAM, worker nodes).

:arrow_forward: Inicialização de modulos terraform

```sh
terraform init
```

:arrow_forward: Planning terraform

```sh
terraform plan -var-file dev.tfvars
```

:arrow_forward: Test terraform

```sh
#terraform apply -var-file dev.tfvars
```

:arrow_forward: Apply terraform

```sh
terraform apply -var-file dev.tfvars
```
## Provisionar infraestrutura com terraform pela pipeline

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
Login e senha default
URL: http://srechallenge-grafana.com

#### Prometheus Server

URL: http://srechallenge-prometheus.com

#### ArgoCD
Login: admin
Para obter a senha execute o comando a seguir:
```sh
make get-password-argocd
```
URL: http://srechallenge-argocd.com

#### Dashboard do kubernetes

Após executar o projeto no kubernetes local com o comando (make run-full-deployments-k8s), colete o token que é exibido e acesse o [link](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

#### Melhorias a fazer

- Colocar secrets nas variáveis de ambiente
- Testar autoscaling dos nodes na aws
- Configurar ExternalDNS para o route53
- Testar pipeline terraform
- Implementar terratest
- Configuração do application no argocd utilizando applicationset
- Implementer Jaeger para realizar traces
 ## Desenvolvedor

 Rodrigo Andrade Mendonça de Oliveira