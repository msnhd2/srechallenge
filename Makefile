# Comandos sumarizados
run-api-local: install-pipenv config-pipenv active-env install-dependencies run-gunicorn
run-api-docker-local: build-image run-container
run-full-deployments-k8s: kind-create-cluster create_namespaces deploy_argocd deploy_grafana \
						  deploy_prometheus deploy_sonarqube deploy_api deploy_fortio

# Para rodar o código localmente execute os seguintes comandos

install-pipenv:
	pip3 install virtualenv==20.16.6

config-pipenv:
	python3 -m virtualenv env --python python3

active-env:
	. ./env/bin/activate

install-dependencies:
	pip install --upgrade pip && pip3 install -r ./api/requirements.txt

run-gunicorn:
	gunicorn --chdir api main:app -b 0.0.0.0:5000

# Para executar o código em docker execute os seguintes comandos
build-image:
	docker build -t flask/flask_docker .

run-container:
	docker run -d -p 5000:5000 flask/flask_docker

# Para executar o lint e validar erros de identação no código execute o comando abaixo
lint:
	autopep8 --in-place -a -a ./api/**/*.py

# Para executar testes unitários
unit-test:
	python3 -m pytest

# Criar cluster localmente
kind-create-cluster:
	kind-create-cluster --name srechallenge --config cluster.yaml

# Criar namespace
create_namespaces:

# Deploy argoCD
deploy_argocd:

# Deploy grafana
deploy_grafana:

# Deploy prometheus
deploy_prometheus:

# Deploy SonarQube
deploy_sonarqube:

# Deploy application
deploy_api:

# Deploy FortIO
deploy_fortio: