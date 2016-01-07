
# whitenoise
STATICFILES_STORAGE = 'whitenoise.django.GzipManifestStaticFilesStorage'
STATIC_ROOT = os.path.join(BASE_DIR, '..', '.staticfiles')

# django-environ
import environ
env = environ.Env()
