import pytest
from main import create_app
#sys.path.insert(0, '/Users/rodrigoandrade/Documents/Projetos/Personal/srechallenge/api')


@pytest.fixture(scope="module")
def app():
    return create_app()