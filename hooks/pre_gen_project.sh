#!/bin/bash

virtualenv --version >/dev/null 2>&1 || { echo >&2 "virtualenv is required to use this cookiecutter"; exit 1; }

virtualenv .ve
.ve/bin/pip install django=={{ cookiecutter.django_version }}
.ve/bin/django-admin.py startproject "{{ cookiecutter.project_name }}" .
if [ "{{ cookiecutter.keep_virtualenv }}" != "yes" ]; then
    rm -rf .ve && echo "---> virtualenv .ve deleted"
else
    echo "---> virtualenv created in .ve"
fi
