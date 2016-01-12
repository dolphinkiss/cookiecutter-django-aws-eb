
# whitenoise
STATICFILES_STORAGE = 'whitenoise.django.GzipManifestStaticFilesStorage'
STATIC_ROOT = os.path.abspath(os.path.join(BASE_DIR, '..', '.staticfiles'))

# email backend that writes to .mailbox directory in BASE_DIR
# this should be overridden in production to functional email backend
EMAIL_BACKEND = 'django.core.mail.backends.filebased.EmailBackend'
EMAIL_FILE_PATH = os.path.abspath(os.path.join(BASE_DIR, '..', '.mailbox'))

# django-environ
import environ
env = environ.Env()
