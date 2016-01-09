# cookiecutter template for Django on AWS Elastic Beanstalk (EB)

This cookiecutter template is for you whom might want to get a Django app running on AWS Elastic Beanstalk.

The template let you choose if you want to use a AWS EB 
[Docker](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-apps.html) deployment or 
[Python](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-apps.html) deployment.

## What you get

* README.md with instructions that will get you started to deploy your django app on AWS EB
* A working local environment
* Dockerfile (in both Python and Docker version)

## Should I choose Python or Docker deployment?

For simplicity you should choose Python deployment, as it is supported. However, there are some problems with
the way how the Python deployment option is configured, such as /static/ is always mapped in their Apache configuration
to a path, that needs a workaround for Whitenoise to work. 
[Take a look at this post at Stackoverflow](http://stackoverflow.com/a/34669173/788022).

The Docker deployment gives you more flexibility, such as you might wanna add something else that runs in the Docker
container. And you can get a quite nice local Docker to AWS EB deployment parity. Meaning, if it works in the Docker
container, you most probably have it working in deployment. The 
[EB CLI](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html) gives you possibility to try out the
deployment locally.


## What is next after using this cookiecutter?

Take a look at the generated README.md for information how to deploy up your django app on AWS Elastic Beanstalk.


## Template variables

* **aws_ebs_type**:    if you want EB python or docker setup
* **project_name**:    django project name, just like in startproject
* **django_version**:  what django version to install
* **setup_local_env**: if we should keep the virtualenvironment with requirements/local.txt installed and
  create postgres database
* **virtualenv_bin**:  location to virtualbin binary, in case it is not in your path, or if you wanna use some other
  virtualenv binary


## Prerequisites

Windows users, sorry, don't think this will work for you :) Pull requests for Windows support are welcome! :)

* cookiecutter (https://github.com/audreyr/cookiecutter)
* virtualenv
* bash
* postgres (createdb), required if **setup_local_env=yes**


## Usage

```
# cookiecutter https://github.com/dolphinkiss/cookiecutter-django-aws-ebs-docker
```


## The hooks

You should take a look at the hooks, so you know that it will not do anything harmful. If you think it does
something harmful, [please create a ticket](https://github.com/dolphinkiss/cookiecutter-django-aws-eb/issues/new)!

### hooks/pre_gen_project.sh

The pre-generation hook will create a virtualenvironment in .ve and then install the specific django
version inside of the virtualenvironment. Then it will run *django-admin.py startproject project_name .*.

It will also assure that you have virtualenv available on your path. If **setup_local_env=yes** then it will also
assure that createdb is on your path.

In case **aws_ebs_type!=docker**, the Dockerrun.aws.json file will be deleted.

### hooks/post_gen_project.sh

The post-generation hook will:

* Rename/move <project_name>/settings.py to <project_name>/settings/common.py
* Patch manage.py and wsgi.py to have **<project_name>.settings.local** as default DJANGO_SETTINGS_MODULE.
* Patch <project_name>/settings/common.py and <project_name>/wsgi.py to have Whitenoise by default

If **setup_local_env=yes** then the post-generation hook will:

* Attempt to create the postgres database <project_name>
* Install requirements/local.txt into the virtualenv

If **setup_local_env!=yes** then the post-generation hook will:

* Remove the .ve directory
