from .common import *

DEBUG = False
ALLOWED_HOSTS = env.list('DJANGO_ALLOWED_HOSTS')
SECRET_KEY = env('DJANGO_SECRET_KEY')
