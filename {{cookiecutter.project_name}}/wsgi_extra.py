
# wraps djangos normal wsgi application in whitenose
from whitenoise.django import DjangoWhiteNoise
application = DjangoWhiteNoise(application)
