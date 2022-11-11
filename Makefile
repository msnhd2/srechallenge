# Para rodar o código localmente execute os seguintes comandos

install-pipenv:
	pip3 install virtualenv==20.16.6

config-pipenv:
	python3 -m virtualenv env --python python3

active-env:
	source env/bin/activate

install-dependencies:
	pip install --upgrade pip && pip3 install -r ./api/requirements.txt

run_gunicorn:
	gunicorn --chdir api main:app -b 0.0.0.0:5000

# Para executar o código em docker execute os seguintes comandos
build image:
	docker build -t flask/flask_docker .

run_container:
	docker run -d -p 5000:5000 flask/flask_docker

# Para executar o lint e validar erros de identação no código execute o comando abaixo
lint:
	autopep8 --in-place -a -a ./api/**/*.py