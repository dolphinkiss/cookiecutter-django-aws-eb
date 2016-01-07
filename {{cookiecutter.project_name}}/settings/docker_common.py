import os
from .common import *

DEBUG = False
ALLOWED_HOSTS = [x.strip() for x in os.getenv('ALLOWED_HOSTS', '').split(',')]
