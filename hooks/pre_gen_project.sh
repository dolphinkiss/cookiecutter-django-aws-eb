#!/bin/bash


require_program() {
    theprogram="$1"
    $theprogram --version >/dev/null 2>&1 || { echo >&2 "---> $theprogram is required for this cookiecutter"; exit 1; }
}

echo "---> Running pre-hook script..."

aws_ebs_type="{{ cookiecutter.aws_ebs_type }}"
if [ "$aws_ebs_type" != "python" ] && [ "$aws_ebs_type" != "docker" ]; then
    echo "---> aws_ebs_type can only have the value of 'python' or 'docker'"; exit 1;
fi

require_program "{{ cookiecutter.virtualenv_bin }}"
if [ "{{ cookiecutter.setup_local_env }}" == "yes" ]; then
    require_program "createdb"
fi

{{ cookiecutter.virtualenv_bin }} .ve
.ve/bin/pip install -q django=={{ cookiecutter.django_version }}
.ve/bin/django-admin.py startproject -v 0 "{{ cookiecutter.project_name }}" .

echo "---> DONE Running pre-hook script..."
