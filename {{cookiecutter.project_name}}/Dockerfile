FROM ubuntu:14.04
MAINTAINER Peter Lauri <peterlauri@gmail.com>

#######################################################
# OS Updates and Python packages
#######################################################

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y

RUN apt-get install -y python-dev python-setuptools nginx supervisor libpq-dev postgresql-client
RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install virtualenv

#######################################################
# Setting up project virtual environment
#######################################################

ADD . /app/{{ project_name }}
RUN virtualenv /app/{{ project_name }}/venv
RUN /app/{{ project_name }}/venv/bin/pip install -r /app/{{ project_name }}/requirements/production.txt


#######################################################
# Setting up uWSGI with supervisor
#######################################################

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD deploy/supervisor_django.conf /etc/supervisor/conf.d/uwsgi_{{ project_name }}.conf
ADD deploy/nginx.conf /etc/nginx/sites-available/{{ project_name }}.conf

RUN ln -s /etc/nginx/sites-available/{{ project_name }}.conf /etc/nginx/sites-enabled
RUN rm -f /etc/nginx/sites-enabled/default


EXPOSE 80

CMD ["supervisord", "-n"]
