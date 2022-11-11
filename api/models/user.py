import re
from sql_alchemy import database
from validate_email import validate_email


class UserModel(database.Model):

    __tablename__ = "users"

    cpf = database.Column(database.String(14), primary_key=True)
    name = database.Column(database.String(20))
    surname = database.Column(database.String(80))
    email = database.Column(database.String(50))
    birthday = database.Column(database.String(20))

    def __init__(self, cpf, name, surname, email, birthday):
        """The contructor method."""
        self.name = name
        self.surname = surname
        self.cpf = cpf
        self.email = email
        self.birthday = birthday

    def json(self):
        """Convert fields to json."""
        return {
            "cpf": self.cpf,
            "name": self.name,
            "surname": self.surname,
            "email": self.email,
            "birthday": self.birthday,
        }

    @classmethod
    def find_user(cls, cpf):
        """Search the database for users using the cpf field."""
        user = cls.query.filter_by(
            cpf=cpf
        ).first()  # SELECT * FROM users WHERE cpf=cpf limit 1
        if user:
            return user
        return None

    def save_user(self):
        """Save user in the database."""
        database.session.add(self)
        database.session.commit()

    def update_user(self, name, surname, email, birthday):
        """Update user fields in the database."""
        self.name = name
        self.surname = surname
        self.email = email
        self.birthday = birthday

    def delete_user(self):
        """Delete users in the database using cpf."""
        database.session.delete(self)
        database.session.commit()

    def is_email_valid(email):
        """Validate if the email format is valid."""
        _valid = validate_email(email)
        return _valid

    def is_cpf_valid(cpf):
        """If cpf in the Brazilian format is valid, it returns True, otherwise, it returns False."""

        # Check if type is str
        if not isinstance(cpf, str):
            return False

        # Remove some unwanted characters
        cpf = re.sub("[^0-9]", "", cpf)

        # Verify if CPF number is equal
        if (
            cpf == "00000000000"
            or cpf == "11111111111"
            or cpf == "22222222222"
            or cpf == "33333333333"
            or cpf == "44444444444"
            or cpf == "55555555555"
            or cpf == "66666666666"
            or cpf == "77777777777"
            or cpf == "88888888888"
            or cpf == "99999999999"
        ):
            return False

        # Checks if string has 11 characters
        if len(cpf) != 11:
            return False

        sum = 0
        weight = 10

        """ Calculating the first cpf check digit. """
        for n in range(9):
            sum = sum + int(cpf[n]) * weight

            # Decrement weight
            weight = weight - 1

        verifyingDigit = 11 - sum % 11

        if verifyingDigit > 9:
            firstVerifyingDigit = 0
        else:
            firstVerifyingDigit = verifyingDigit

        """ Calculating the second check digit of cpf. """
        sum = 0
        weight = 11
        for n in range(10):
            sum = sum + int(cpf[n]) * weight

            # Decrement weight
            weight = weight - 1

        verifyingDigit = 11 - sum % 11

        if verifyingDigit > 9:
            secondVerifyingDigit = 0
        else:
            secondVerifyingDigit = verifyingDigit

        if cpf[-2:] == "%s%s" % (firstVerifyingDigit, secondVerifyingDigit):
            return True
        return False
