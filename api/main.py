#!/usr/bin/env python3

import os
from dotenv import load_dotenv
from flask import Flask
from flask_restful import Api
from resources.user import Users, User, Healthcheck
from sql_alchemy import database

# Load variables
load_dotenv(override=True)
SQLALCHEMY_DATABASE_URI = os.getenv("SQLALCHEMY_DATABASE_URI")
SQL_TRACK_MODIFICATIONS = os.getenv("SQL_TRACK_MODIFICATIONS")
DATABASE_NAME = os.getenv("DATABASE_NAME")
HOST = os.getenv("HOST")
PORT = os.getenv("PORT")

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = SQLALCHEMY_DATABASE_URI
app.config["SQL_TRACK_MODIFICATIONS"] = SQL_TRACK_MODIFICATIONS
api = Api(app)


@app.before_first_request
def create_database():
    database.init_app(app)
    database.create_all()

def create_app():
    return app

#Rotas da aplicação
api.add_resource(Users, "/users")
api.add_resource(User, "/users/<string:cpf>")
api.add_resource(Healthcheck,"/healthcheck")

if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=False)
