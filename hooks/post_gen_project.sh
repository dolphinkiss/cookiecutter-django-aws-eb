#!/bin/bash

mv settings_production.py "{{ cookiecutter.project_name }}/"
mv settings_local.py "{{ cookiecutter.project_name }}/"

if [ "{{ cookiecutter.setup_local_env }}" == "yes" ]; then
    createdb "{{ cookiecutter.project_name }}" \
        && echo "---> Created postgres database {{ cookiecutter.project_name }}" \
        || echo -n "---> Failed to create database {{ cookiecutter.project_name }}." \
                "     If the database does not exist, running locally will not work."
    # installing local pip packages
    .ve/bin/pip install -r requirements/local.txt
    # replacing the original settings that is referenced in manage.py
    sed -i "" -e 's/{{ cookiecutter.project_name }}.settings/{{ cookiecutter.project_name }}.settings_local/g' manage.py
else
    rm -rf .ve && echo "---> virtualenv .ve deleted"
fi
