from models.user import UserModel


def test_cad_valid_cpf():
    assert UserModel.is_cpf_valid('12764599714') == True


def test_cad_invalid_cpf():
    assert UserModel.is_cpf_valid('12764599716') == False


def test_cad_valid_email():
    assert UserModel.is_email_valid('rodrigo@hotmail.com') == True


def test_cad_invalid_email():
    assert UserModel.is_email_valid('rodrigoandrade') == False
