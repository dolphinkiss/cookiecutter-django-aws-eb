from .deploy_common import *

INSTALLED_APPS += [
    'storages',
]

DEFAULT_FILE_STORAGE = 'storages.backends.s3boto.S3BotoStorage'

AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = os.getenv('AWS_STORAGE_BUCKET_NAME')

# the RDS_* environment variables comes from the AWS EB environment, and is
# set automatically by AWS Elastic Beanstalk when using a connected RDS
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.getenv('RDS_DB_NAME'),
        'USER': os.getenv('RDS_USERNAME'),
        'PASSWORD': os.getenv('RDS_PASSWORD'),
        'HOST': os.getenv('RDS_HOSTNAME'),
        'PORT': os.getenv('RDS_PORT'),
    }
}

{% if cookiecutter.aws_eb_type == "python" %}
# we should assure that we don't use /static/ in case we want to keep using whitenoise
# as there is a default static handler on /static/ that cannot be removed for the moment.
# See: http://stackoverflow.com/a/34669173/788022
STATIC_URL = '/staticfiles/'
{% endif %}
