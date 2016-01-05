# cookiecutter template just like the built in *django-admin.py startproject* :)

This template isn't really useful, as it does the same as *django-admin.py startproject*. But I created it
to keep as upstream for other cookiecutter django templates.

## Prerequisites

* cookiecutter (https://github.com/audreyr/cookiecutter)
* virtualenv
* bash

## Template variables

* *project_name*: django project name, just like in startproject
* *django_version*: what django version to install
* *keep_virtualenv*: if we should keep the virtualenvironment that was created in the pre hook script,
  any non "yes" value will remove the .ve directory

## Usage

```
# cookiecutter https://github.com/dolphinkiss/cookiecutter-django-startproject
```

## How it works

The pre-generation hook will create a virtualenvironment in .ve and then install the specific django
version inside of the virtualenvironment. Then it will run *django-admin.py startproject project_name .*.
If you have answered a non-yes answer to keep_virtuelenv, it will delete the .ve directory.