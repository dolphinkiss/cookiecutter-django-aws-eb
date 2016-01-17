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

# AWS EB Load Balancer will add X-Forwarded-Proto to headers for the incoming request
# to http or https, depending on what the client requested. This is later used in django
# request.is_secure() to determine if the request is secure or not. See:
# https://docs.djangoproject.com/en/1.9/ref/settings/#secure-proxy-ssl-header
# http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/x-forwarded-headers.html#x-forwarded-proto
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

## email settings, comment out if you wanna send out emails from the system
## Use AWS SES for example to get your emails functional
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
#EMAIL_HOST = env('DJANGO_EMAIL_HOST')
#EMAIL_HOST_USER = env('DJANGO_EMAIL_HOST_USER')
#EMAIL_HOST_PASSWORD = env('DJANGO_EMAIL_HOST_PASSWORD')
#EMAIL_PORT = 587
#EMAIL_USE_TLS = True

## error reporting, see django error reporting documentation see, set the below to proper
## values to reflect your
## https://docs.djangoproject.com/en/1.9/howto/error-reporting/
# ADMINS = [('Root Localhost', 'root@localhost')]
# MANAGERS = ADMINS

{% if cookiecutter.aws_eb_type == "python" %}
# we should assure that we don't use /static/ in case we want to keep using whitenoise
# as there is a default static handler on /static/ that cannot be removed for the moment.
# See: http://stackoverflow.com/a/34669173/788022
STATIC_URL = '/staticfiles/'
{% endif %}
