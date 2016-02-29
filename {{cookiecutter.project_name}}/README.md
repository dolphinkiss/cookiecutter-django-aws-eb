# {{ cookiecutter.project_name|upper }}

## Usage

For instruction on how to use the EB CLI, visit the 
[EB CLI](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html) documentation.

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
# eb create -db.engine postgres --envvars \
    'DJANGO_SECRET_KEY=<V>,AWS_ACCESS_KEY_ID=<V>,AWS_SECRET_ACCESS_KEY=<V>,AWS_STORAGE_BUCKET_NAME=<V>'
```

The initial creation of the environment will take some time, between 5-15 minutes. EC2 instances, Load Balancers and
RDS database (Postgresql), will be created. And initial docker image will be built.

After it has started up (green), check the CNAME and then set the DJANGO_ALLOWED_HOSTS.

```
# eb setenv "DJANGO_ALLOWED_HOSTS=<CNAME>"
```

When that has completed, just visit **http://<CNAME>/admin**, and it should be bring up the login form. Don't be
surprised that **http://<CNAME>/** will respond 404, as there is no URL mapping in initial django setup. You have to 
create your own app for that, that is your job :)

Create a superuser, and you should be able to login:

{% if cookiecutter.aws_eb_type == "docker" %}
```
# eb ssh          # ssh into the EC2 instance
# sudo /home/ec2-user/django-manage.sh createsuperuser  # you have to sudo, as it is required to access the container
```
{% else %}
```
# eb ssh          # ssh into the EC2 instance
# /home/ec2-user/django-manage.sh createsuperuser
```
{% endif %}

#### Logs

You will view logs from the instances by running **eb logs**. 

{% if cookiecutter.aws_eb_type == "docker" %}
Docker container logs are located at **/var/log/eb-docker/containers/eb-current-app**.
{% endif %}


#### Running django management commands on the EC2 instances

There is a script located at **/home/ec2-user/django-manage.sh** that you can use to run management commands
{% if cookiecutter.aws_eb_type == "docker" %}inside of the docker container{% endif %}.

{% if cookiecutter.aws_eb_type == "docker" %}
**The script needs to be run as root**, to be able to access the docker container
{% endif %}


#### Enable HTTPS

Follow this guide: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/configuring-https.html

What it will do is to change the port that the load balancer listen to. If you follow the guide you will
end up only accepting https, and http requests will not pass the load balancer. This is in most cases
not wanted, as you probably want a permanent redirect (301) on http://DOMAIN/ to https://DOMAIN/.

{% if cookiecutter.aws_eb_type == "docker" %}
If you want to enable http -> https redirect in docker environment:

* Enable http port in load balancer, together with https port
* Uncomment the section about redirection in **docker/nginx.conf** and deploy the app again (**eb deploy**).
  To understand the rule, you should read about [Elastic Load Balancer X-Forwarded HEaders](http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/x-forwarded-headers.html#x-forwarded-proto)

settings.aws_eb is configured with **SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')** to make
django request.is_secure() function properly in case you have enabled HTTPS. 

{% endif %}

{% if cookiecutter.aws_eb_type == "python" %}
If you want to enable http -> https redirect, I don't have the answer for you. If you have the answer, please
make the changes and create a Pull Request :)
{% endif %}

{% if cookiecutter.aws_eb_type == "docker" %}
### eb local

If you have docker installed, you can run the container locally. The DJANGO_ALLOWED_HOSTS setting in eb local mode 
should be set to the IP address of the host machine, or in case of OSX the virtual machines shared IP. 
DJANGO_DATABASE_URL is also required. See https://github.com/kennethreitz/dj-database-url#url-schema for supported 
formats.

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
{% endif %}

{% if cookiecutter.setup_local_env == "yes" %}
### Local runserver setup

**Settings file**: {{ cookiecutter.source_root }}/{{ cookiecutter.project_name }}/settings/local.py

```
# source .ve/bin/activate
# {{ cookiecutter.source_root }}/manage.py migrate
# {{ cookiecutter.source_root }}/manage.py collectstatic
# {{ cookiecutter.source_root }}/manage.py runserver
```

{% endif %}


## Limitations / WARNING

You should be aware that this is only a template for getting your app up and running using AWS Elastic Beanstalk.
The Django project created by this, has minimal settings, and not configured to send out emails, nor using SSL.


## Notes

Remember that using AWS Elastic Beanstalk will cause charges on your AWS account. If you are a new user, you can use
the free tier for one year.
