# {{ cookiecutter.project_name }}

## Prerequisites

* 
AWS Elastic Beanstalk command line client: pip install awsebcli
* 


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
you also need to set the ALLOWED_HOSTS environment variable. You can have multiple allowed hosts, by separating them
with comma. Example:

```
# eb setenv ALLOWED_HOSTS=www.example.com,mycoolproject.elasticbeanstalk.com
```

## Notes

Remember that using AWS Elastic Beanstalk will cause charges on your AWS account. If you are a new user, you can use
the free tier for one year.
