FROM python:3.8-alpine
# Impede o python de gravar arquivos pyc no disco
ENV PYTHONDONTWRITEBYTECODE 1
# Impede o python de armazenar em buffer stdout e stderr
ENV PYTHONUNBUFFERED 1  

COPY api /app

WORKDIR /app

RUN pip3 install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["gunicorn", "main:app", "-b", "0.0.0.0:5000"]