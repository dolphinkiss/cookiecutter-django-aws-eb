# cookiecutter template for Django on AWS Elastic Beanstalk Docker

This template is for you whom might want to get a Django app running on AWS Elastic Beanstalk with Docker. 

Using AWS EB Docker deployments is not the only way to get your Django app running on AWS, take a look here as well: 
(http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-apps.html).


## What you get

Some basic setup for getting a working AWS EB Docker Django deployment. The docker container runs **uwsgi+nginx** and
exposes port 80 that is mapped to the AWS Elastic Load Balancer. Of course you optionally get a working local
development environment as well.


## What is next after using this cookiecutter?

Take a look at the generated README.md for information how to start up your first AWS Elastic Beanstalk app deployment.


## Template variables

* **project_name**:    django project name, just like in startproject
* **django_version**:  what django version to install.
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
# cookiecutter https://github.com/dolphinkiss/cookiecutter-django-aws-eb-docker
```


## The hooks

You should take a look at the hooks, so you know that it will not do anything harmful. If you think it does
something harmful, please create a ticket!

### hooks/pre_gen_project.sh

The pre-generation hook will create a virtualenvironment in .ve and then install the specific django
version inside of the virtualenvironment. Then it will run *django-admin.py startproject project_name .*.
If you have answered a non-yes answer to **setup_local_env**, it will delete the .ve directory.

It will also assure that you have virtualenv and postgres (createdb) available on your path.

### hooks/post_gen_project.sh

The post-generation hook will:

* Rename/move <project_name>/settings.py to <project_name>/settings/common.py
* Patch manage.py to have **<project_name>.settings.local** as default DJANGO_SETTINGS_MODULE.

If **virtualenv_bin=yes** then the post-generation hook will:

* Attempt to create the postgres database <project_name>
* Install requirements/local.txt into the virtualenv

If **virtualenv_bin!=yes** then the post-generation hook will:

* Remove the .ve directory
