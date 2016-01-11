from .common import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ cookiecutter.project_name }}',
    }
}

# DEBUG = False
# ALLOWED_HOSTS=['127.0.0.1']
