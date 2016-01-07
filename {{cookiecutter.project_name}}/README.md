# {{ cookiecutter.project_name }}

## Usage

For instruction on how to use the EB CLI, visit (http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)

### eb

The following variables is needed for the app to be able to store/serve media files.

* AWS_ACCESS_KEY_ID:       AWS access id to access your S3 bucket
* AWS_SECRET_ACCESS_KEY:   AWS access key to access your S3 bucket
* AWS_STORAGE_BUCKET_NAME: AWS S3 bucket name
* DJANGO_SECRET_KEY:       SECRET_KEY, should be kept secret, and uniqe.
* DJANGO_ALLOWED_HOSTS:           Comma separated list of allowed hosts

```
# eb init
# eb create --database.engine postgres --envvars \
    'AWS_ACCESS_KEY_ID=<V>,AWS_SECRET_ACCESS_KEY=<V>,AWS_STORAGE_BUCKET_NAME=<V>'
```

The initial creation of the environment will take some time, between 5-15 minutes. EC2 instances, Load Balancers and
RDS database (Postgresql), will be created. And initial docker image will be built.


### eb local

If you have docker installed, you can run the container locally. The DJANGO_ALLOWED_HOSTS setting in eb local mode 
refers to the IP address of the host machine, or in case of OSX the virtual machines shared IP.

```
# eb init
# eb local setenv "DJANGO_SETTINGS_MODULE={{ cookiecutter.project_name }}.settings.docker_local"
# eb local setenv "DJANGO_ALLOWED_HOSTS=192.168.99.100"
# eb local run
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

If you 

```
```

## Prerequisites

* AWS Elastic Beanstalk command line client: pip install awsebcli
* 


## References

* **AWS Elastic Beanstalk CLI**: (http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)


# FROM OLD README

# django-startproject-template-aws-eb-docker for django 1.9

This is intended for people that want to use AWS Elastic Beanstalk with Docker for deployments. 

Before you use this, you might consider AWS EB Python app deployments: 
(http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-apps.html).

This is kept in sync with "upstream" (https://github.com/dolphinkiss/django-startproject-template-copy) project.

## Limitations / WARNING

You should be aware that this is only a template for getting your app up and running using AWS Elastic Beanstalk.
The Django project created by this, has minimal settings, and not configured to send out emails, nor using SSL.

## Usage

* Create a Virtualenv
* Install awsebcli package (alternative is to install it globally)
* Install django into the Virtualenv

Fork/download this project, make your changes, and then start your projects using:

```
# django-admin.py startproject --template <local template path or github link> --extension=py,conf,docker <projectname> 
```

Django will only process py files by default, with --extension this is overridden. Due to some limitations in
django-admin.py startproject --template functionality, you have to:

* rename Dockerfile.docker to Dockerfile after you started your project
* rename the directory ebextensions to .ebextensions

You have to create a S3 bucket and set configuration values in **.ebextensions/environment.config**

Example:

```
# virtualenv .ve
# source .ve/bin/activate
# pip install django==1.9.1 awsebcli
# django-admin.py startproject \
    --template https://github.com/dolphinkiss/django-startproject-template-aws-eb-docker/archive/master.zip \
    --extension=py,conf,docker,config mycoolproject
# cd mycoolproject
# mv Dockerfile.docker Dockerfile
# mv ebextensions .ebextensions
# eb init
# eb create --database.engine postgres --envvars \
    'AWS_ACCESS_KEY_ID=<V>,AWS_SECRET_ACCESS_KEY=<V>,AWS_STORAGE_BUCKET_NAME=<V>'
```

Replace <V> with your own values.

* AWS_ACCESS_KEY_ID: AWS access id to access your S3 bucket
* AWS_SECRET_ACCESS_KEY: AWS access key to access your S3 bucket
* AWS_STORAGE_BUCKET_NAME: AWS S3 bucket name

When those commands has run and completed, you will have a Django app running ontop of AWS Elastic Beanstalk
where static and media files are served via AWS S3, and a AWS RDS Postgresql database. However, because DEBUG=False
you also need to set the DJANGO_ALLOWED_HOSTS environment variable. You can have multiple allowed hosts, by separating 
them with comma. Example:

```
# eb setenv ALLOWED_HOSTS=www.example.com,mycoolproject.elasticbeanstalk.com
```

## Notes

Remember that using AWS Elastic Beanstalk will cause charges on your AWS account. If you are a new user, you can use
the free tier for one year.
