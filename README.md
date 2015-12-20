# django-startproject-template-copy from django 1.9

This is just to simplify for the ones who looked where the project template is located, to create your own.

The files are copied **as is** from (https://github.com/django/django/tree/1.9.1/django/conf/project_template) 
commit id 76e0d43 (tag 1.9.1).

## Usage

* Create a Virtualenv
* Install django into the Virtualenv

Fork/download this project, make your changes, and then start your projects using:

```
# django-admin.py startproject --template <local template path or github link> <projectname> 
```

If you want also have none py files, you need to use the *--extensions=py* argument to the startproject command.

Example that will use py and md files:

```
# virtualenv .ve
# source .ve/bin/activate
# pip install django
# django-admin.py startproject \
    --template https://github.com/dolphinkiss/django-startproject-template-copy/archive/master.zip \
    --extensions=py,md
```

