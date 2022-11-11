FROM python:3.8-alpine

COPY api/requirements.txt /
RUN pip3 install -r /requirements.txt

COPY api /app

WORKDIR /app

EXPOSE 5000

ENTRYPOINT ["gunicorn", "main:app", "-b", "0.0.0.0:5000"]