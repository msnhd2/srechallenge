# Comandos sumarizados
run-api-local: install-pipenv config-pipenv active-env install-dependencies run-gunicorn
run-api-docker-local: build-image run-container
run-full-deployments-k8s: kind-create-cluster create-ingress-controller create_namespace deploy_api deploy_argocd \
						  deploy_grafana deploy_prometheus deploy_sonarqube deploy_fortio create-kub-dashboard

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
	docker build -t msnhd2/flask_docker .

run-container:
	docker run -d -p 5000:5000 msnhd2/flask_docker

# Para executar o lint e validar erros de identação no código execute o comando abaixo
lint:
	autopep8 --in-place -a -a ./api/**/*.py

# Para executar testes unitários
unit-test:
	python3 -m pytest

# Criar cluster localmente
kind-create-cluster:
	kind create cluster --config ./kubernetes/cluster.yaml

# Criar Web UI Dashboard do kubernetes
# Habilitar acesso ao dashboard
# Criação da service account e dar o bind
# Get token para autenticar
create-kub-dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml && \
	kubectl proxy && \
	kubectl apply -f ./kubernetes/kub-dash/dashboard_user.yaml -n kubernetes-dashboard && \
	kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | awk '/^secret-admin-user/{print $1}') | awk '$1=="token:"{print $2}'

# Criar metrics-server
create-metrics-server:


# Criar ingress controller nginx
create-ingress-controller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy

# Criar namespace
create-namespace:
	kubectl apply -f ./kubernetes/namespaces.yaml

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
	kubectl apply -f ./kubernetes/app/kustomize.yaml
	kubectl port-forward -n srechallenge service/srechallenge 5000:5000

# Deploy FortIO
# Criar um Usuário com um comando curl
# Executar fortio consultando o usuário criado
deploy_fortio: