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

do_patch_manage_py() {
    mv "{{ cookiecutter.project_name }}/settings.py" "settings/common.py"
    sed -i "" -e "s/{{ cookiecutter.project_name }}.settings/settings.local/g" "manage.py"
}

do_remove_ve() {
    rm -rf .ve && echo "---> virtualenv .ve deleted"
}

# post hook actions
echo "---> Running post-hook script..."

do_patch_manage_py
if [ "{{ cookiecutter.setup_local_env }}" == "yes" ]; then
    do_createdb
    do_install_local_requirements
else
    do_remove_ve
fi

echo "---> DONE Running post-hook script..."
