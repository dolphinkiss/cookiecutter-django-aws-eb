from .deploy_common import *

DATABASES = {
    'default': env.db('DJANGO_DATABASE_URL'),
}