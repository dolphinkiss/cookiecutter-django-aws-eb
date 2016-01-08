# {{ cookiecutter.project_name }}

## Usage

For instruction on how to use the EB CLI, visit (http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)

### eb

The following variables is needed for the app to be able to store/serve media files. Some of them should be kept
secret.

* AWS_ACCESS_KEY_ID:       AWS access id to access your S3 bucket
* AWS_SECRET_ACCESS_KEY:   AWS access key to access your S3 bucket
* AWS_STORAGE_BUCKET_NAME: AWS S3 bucket name
* DJANGO_SECRET_KEY:       settings.SECRET_KEY (required)
* DJANGO_ALLOWED_HOSTS:    settings.ALLOWED_HOSTS, comma separated list (required)

```
# eb init
# eb create --database.engine postgres --envvars \
    'DJANGO_SECRET_KEY=<V>,AWS_ACCESS_KEY_ID=<V>,AWS_SECRET_ACCESS_KEY=<V>,AWS_STORAGE_BUCKET_NAME=<V>'
```

The initial creation of the environment will take some time, between 5-15 minutes. EC2 instances, Load Balancers and
RDS database (Postgresql), will be created. And initial docker image will be built.

After it has started up (green), check the CNAME and then set the DJANGO_ALLOWED_HOSTS.

```
# eb setenv "DJANGO_ALLOWED_HOSTS=<CNAME>"
```

When that has completed, just visit **http://<CNAME>/admin**, and it should be bring up the login form.

Create a superuser, and you should be able to login:

```
# eb ssh          # ssh into the EC2 instance
# sudo docker ps  # remember the container id for later
# sudo docker exec -it <CONTAINER ID> /app/.vedocker/bin/python /app/manage.py createsuperuser
```


### eb local

If you have docker installed, you can run the container locally. The DJANGO_ALLOWED_HOSTS setting in eb local mode 
refers to the IP address of the host machine, or in case of OSX the virtual machines shared IP. DJANGO_DATABASE_URL
is also required. See https://github.com/kennethreitz/dj-database-url#url-schema for supported formats.

```
# eb init
# eb local setenv "DJANGO_SETTINGS_MODULE={{ cookiecutter.project_name }}.settings.docker"
# eb local setenv "DJANGO_ALLOWED_HOSTS=192.168.99.100"
# eb local setenv "DJANGO_DATABASE_URL=sqlite:////app/sqlite.db"
# eb local run
```

You should now be able to visist **http://<IP>/admin**. But you need to run migrations and create superuser.

In a separate terminal do this, and after that try to login.

```
# docker ps      # remember the container id for later
# docker exec <CONTAINER ID> /app/.vedocker/bin/python /app/manage.py migrate --noinput
# docker exec -it <CONTAINER ID> /app/.vedocker/bin/python /app/manage.py createsuperuser
```


{% if cookiecutter.setup_local_env == "yes" %}
### Local runserver setup

**Settings file**: {{ cookiecutter.project_name }}/settings/local.py

```
# source .ve/bin/activate
# ./manage.py migrate
# ./manage.py collectstatic
# ./manage.py runserver
```

{% endif %}


## Limitations / WARNING

You should be aware that this is only a template for getting your app up and running using AWS Elastic Beanstalk.
The Django project created by this, has minimal settings, and not configured to send out emails, nor using SSL.


## Notes

Remember that using AWS Elastic Beanstalk will cause charges on your AWS account. If you are a new user, you can use
the free tier for one year.




## Stuff to add related to python environment

/home/ec2-user/django-manage.sh is script for running management commands
