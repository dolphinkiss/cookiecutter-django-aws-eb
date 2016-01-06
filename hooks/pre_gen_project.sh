#!/bin/bash


require_program() {
    theprogram="$1"
    $theprogram --version >/dev/null 2>&1 || { echo >&2 "---> $theprogram is required for this cookiecutter"; exit 1; }
}

echo "---> Running pre-hook script..."

require_program "{{ cookiecutter.virtualenv_bin }}"
require_program "createdb"
if [ "{{ cookiecutter.setup_local_env }}" == "yes" ]; then
    require_program "createdb"
fi

{{ cookiecutter.virtualenv_bin }} .ve
.ve/bin/pip install -q django=={{ cookiecutter.django_version }}
.ve/bin/django-admin.py startproject -v 0 "{{ cookiecutter.project_name }}" .

echo "---> DONE Running pre-hook script..."
