#!/bin/bash

# functions
do_createdb() {
    # attempt to create the postgres database
    createdb "{{ cookiecutter.project_name }}" \
        && echo "---> Created postgres database '{{ cookiecutter.project_name }}'" \
        || { echo "---> Failed to create database '{{ cookiecutter.project_name }}'.\n"; \
             echo "     If the database does not exist, running locally will not work."; }
}

do_install_local_requirements() {
    .ve/bin/pip install -q -r requirements/local.txt
}

do_patch_settings_and_manage_py() {
    mv "settings" "{{ cookiecutter.project_name }}/"

    WSGI_PATH="{{ cookiecutter.project_name }}/wsgi.py"
    COMMON_SETTINGS="{{ cookiecutter.project_name }}/settings/common.py"

    mv "{{ cookiecutter.project_name }}/settings.py" "$COMMON_SETTINGS"
    cat "settings_extra.py" >> "$COMMON_SETTINGS" && rm "settings_extra.py"

    sed -i "" -e "s/{{ cookiecutter.project_name }}.settings/{{ cookiecutter.project_name }}.settings.local/g" "manage.py" "$WSGI_PATH"
}

do_patch_wsgi_py_whitenoise() {
    WSGI_PATH="{{ cookiecutter.project_name }}/wsgi.py"
    cat "wsgi_extra.py" >> "$WSGI_PATH" && rm "wsgi_extra.py"
}

do_remove_ve() {
    rm -rf .ve && echo "---> virtualenv .ve deleted"
}

# post hook actions
echo "---> Running post-hook script..."

do_patch_settings_and_manage_py
do_patch_wsgi_py_whitenoise
if [ "{{ cookiecutter.setup_local_env }}" == "yes" ]; then
    do_createdb
    do_install_local_requirements
else
    do_remove_ve
fi

if [ "{{ cookiecutter.aws_eb_type }}" != "docker" ]; then
    rm Dockerrun.aws.json
fi

echo "---> DONE Running post-hook script..."
