#!/bin/bash

require_program() {
    theprogram="$1"
    $theprogram --version >/dev/null 2>&1 || { echo >&2 "$theprogram is required to use this cookiecutter"; exit 1; }
}

require_program "virtualenv"
require_program "createdb"

virtualenv .ve
.ve/bin/pip install django=={{ cookiecutter.django_version }}
.ve/bin/django-admin.py startproject "{{ cookiecutter.project_name }}" .
