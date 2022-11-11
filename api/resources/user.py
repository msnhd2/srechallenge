from flask_restful import Resource, reqparse
from models.user import UserModel


class Users(Resource):
    def get(self):
        """Returns a list with all users registered in the database"""

        return {
            "users": [user.json() for user in UserModel.query.all()]
        }  # select * from users


class User(Resource):
    arguments = reqparse.RequestParser()
    arguments.add_argument("name")
    arguments.add_argument("surname")
    arguments.add_argument("email")
    arguments.add_argument("birthday")

    def get(self, cpf):
        """Returns the specific user based on cpf"""

        user = UserModel.find_user(cpf)
        if user:
            return user.json()
        return {"message": "User not found."}, 404

    def post(self, cpf):
        """Registers the user, validating if the cpf and e-mail provided are in the valid format, and effetuate"""

        if UserModel.find_user(cpf):
            return {"message": "CPF '{}' already existis.".format(cpf)}, 400
        if UserModel.is_cpf_valid(cpf):
            data = User.arguments.parse_args()
            user = UserModel(cpf, **data)
            email = user.json()["email"]
            if UserModel.is_email_valid(email):
                try:
                    user.save_user()
                except BaseException:
                    return {
                        "message": "An internal error ocurred trying to save user."}, 500
                return user.json()
            return {
                "message": "The format of email: '{}' is not valid.".format(email)}, 400
        else:
            return {"message": "CPF '{}' is invalid.".format(cpf)}, 400

    def put(self, cpf):
        """ """
        data = User.arguments.parse_args()

        user_found = UserModel.find_user(cpf)
        if user_found:
            user_found.update_user(**data)
            user_found.save_user()
            return user_found.json(), 200  # user existis
        user = UserModel(cpf, **data)
        try:
            user.save_user()
        except BaseException:
            return {
                "message": "An internal error ocurred trying to save user."
            }, 500  # Internal server error
        return user.json(), 201  # created new user

    def delete(self, cpf):
        """ """
        user = UserModel.find_user(cpf)
        if user:
            try:
                user.delete_user()
            except BaseException:
                return {
                    "message": "An  error ocurred trying to delete user."}, 500
            return {"message": "User deleted"}
        return {"message": "User not found."}, 404
