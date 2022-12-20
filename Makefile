# Comandos sumarizados
run-api-local: install-pipenv config-pipenv active-env install-dependencies run-gunicorn
run-api-docker-local: build-image run-container
run-full-deployments-k8s: kind-create-cluster create-metrics-server create-ingress-controller create-namespaces \
						  deploy-api deploy-argocd deploy-grafana deploy-prometheus create-kub-dashboard

# Para rodar o código localmente execute os seguintes comandos

install-pipenv:
	pip3 install virtualenv==20.16.6

config-pipenv:
	python3 -m virtualenv env --python python3

active-env:
	. ./env/bin/activate

install-dependencies:
	sudo pip3 install -r ./api/requirements.txt

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

unit-test-report-sonar:
	tox -e py
# unit-test-report-sonar:
# 	coverage run --source=./api -m pytest && coverage report && coverage xml

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
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml

# Criar ingress controller nginx
create-ingress-controller:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy

# Criar namespace
create-namespaces:
	kubectl apply -f ./kubernetes/namespaces.yaml

# Criar metrics-server
create-metrics-state-server:
	kubectl apply -f ./kubernetes/metrics --recursive

# Deploy argoCD
deploy-argocd:

# Deploy grafana
deploy-grafana:
kubectl apply -f kubernetes/grafana --recursive

# Deploy prometheus
deploy-prometheus:
kubectl apply -f kubernetes/prometheus --recursive

# Deploy application
deploy-api:
	kubectl apply -f ./kubernetes/app --recursive

# Port Forwarding to all services
# Utilizei o & para que os comandos sejam executados em segundo plano
port-Forwarding:
	kubectl port-forward -n srechallenge service/srechallenge 5000:5000 & \
	kubectl port-forward -n monitoring service/prometheus-service 8000:8080 & \
	kubectl port-forward -n monitoring service/grafana-service 32000:3000

# Executar fortio
# 800 requisições/segundo
# Duração de 2 minutos
# 70 conexçoes simultaneas
running_fortio:
	kubectl run -it fortio -n srechallenge --rm --image=fortio/fortio -- load -qps 800 -t 120s -c 70 "http://srechallenge-api-svc:5000/healthz"