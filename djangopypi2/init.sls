{#-
Copyright (c) 2013, Hung Nguyen Viet
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Hung Nguyen Viet hvnsweeting@gmail.com
Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
-#}
include:
  - postgresql
  - postgresql.server
  - virtualenv
  - uwsgi
  - local
  - nginx
  - pip
  - web
  - python.dev
  - apt
  - memcache
  - rsyslog
{% if salt['pillar.get']('djangopypi2:ssl', False) %}
  - ssl
{% endif %}
{% if 'graphite_address' in pillar %}
  - statsd
{% endif %}

{%- set root_dir = "/usr/local/djangopypi2" %}

djangopypi2:
  virtualenv:
    - manage
    - name: /usr/local/djangopypi2
    - no_site_packages: True
    - require:
      - module: virtualenv
      - file: /usr/local
  file:
    - managed
    - name: /usr/local/djangopypi2/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://djangopypi2/requirements.jinja2
    - require:
      - virtualenv: djangopypi2
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/djangopypi2/bin/pip
    - requirements: /usr/local/djangopypi2/salt-requirements.txt
    - require:
      - virtualenv: djangopypi2
    - watch:
      - pkg: python-dev
      - pkg: postgresql-dev
      - file: djangopypi2
  cmd:
    - wait
    - name: find /usr/local/djangopypi2 -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: djangopypi2
  postgres_user:
    - present
    - name: {{ salt['pillar.get']('djangopypi2:db:username', 'djangopypi2') }}
    - password: {{ salt['password.pillar']('djangopypi2:db:password', 10) }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('djangopypi2:db:name', 'djangopypi2') }}
    - owner: {{ salt['pillar.get']('djangopypi2:db:username', 'djangopypi2') }}
    - runas: postgres
    - require:
      - postgres_user: djangopypi2
      - service: postgresql

djangopypi2_urls:
  file:
    - managed
    - name: {{ root_dir }}/lib/python2.7/site-packages/djangopypi2/website/urls.py
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - module: djangopypi2
    - source: salt://djangopypi2/urls.jinja2

djangopypi2_settings:
  file:
    - managed
    - name: {{ root_dir }}/lib/python2.7/site-packages/djangopypi2/website/settings.py
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - module: djangopypi2
    - source: salt://djangopypi2/config.jinja2
  module:
    - wait
    - name: django.syncdb
    - settings_module: djangopypi2.website.settings
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2
      - service: rsyslog
    - watch:
      - file: djangopypi2_settings
      - file: djangopypi2_urls

{{ root_dir }}/manage:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://django/manage.jinja2
    - context:
      settings: djangopypi2.website.settings
      virtualenv: {{ root_dir }}
    - require:
      - virtualenv: djangopypi2

djangopypi2_collectstatic:
  module:
    - wait
    - name: django.collectstatic
    - settings_module: djangopypi2.website.settings
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2_settings
      - cmd: djangopypi2
    - watch:
      - file: djangopypi2_settings
      - module: djangopypi2

djangopypi2_loaddata:
  module:
    - wait
    - name: django.loaddata
    - settings_module: djangopypi2.website.settings
    - fixtures: initial
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2_settings
    - watch:
      - postgres_database: djangopypi2

djangopypi2_admin_user:
  module:
    - wait
    - name: django.command
    - command: createsuperuser_plus --username={{ pillar['djangopypi2']['initial_admin_user']['username'] }} --email={{ salt['pillar.get']('djangopypi2:initial_admin_user:email', 'root@example.com') }} --password={{ pillar['djangopypi2']['initial_admin_user']['password'] }}
    - settings_module: djangopypi2.website.settings
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2_loaddata
    - watch:
      - postgres_database: djangopypi2

{{ root_dir }}/django_contrib_sites.yaml:
  file:
    - absent

{# set django.contrib.sites.models.Site id=1 #}
djangopypi2-django_contrib_sites:
  file:
    - managed
    - name: {{ root_dir }}/django_contrib_sites.xml
    - source: salt://django/site.jinja2
    - template: jinja
    - context:
      domain_name: {{ pillar['djangopypi2']['hostnames'][0] }}
    - user: root
    - group: root
    - mode: 440
  module:
    - wait
    - name: django.loaddata
    - settings_module: djangopypi2.website.settings
    - fixtures: {{ root_dir }}/django_contrib_sites.xml
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2_settings
      - file: djangopypi2-django_contrib_sites
    - watch:
      - postgres_database: djangopypi2

/var/lib/deployments/djangopypi2/media:
  file:
    - directory
    - user: www-data
    - group: www-data
    - makedirs: True

/etc/uwsgi/djangopypi2.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://uwsgi/template.jinja2
    - context:
      chdir: {{ root_dir }}
      appname: djangopypi2
      module: djangopypi2.website.wsgi
      django_settings: djangopypi2.website.settings
      virtualenv: {{ root_dir }}
    - require:
      - service: uwsgi_emperor
      - postgres_database: djangopypi2
      - service: memcached
      - service: rsyslog
      - module: djangopypi2-django_contrib_sites
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/djangopypi2.ini
    - watch:
      - cmd: djangopypi2
      - file: djangopypi2_settings
      - file: djangopypi2_urls
      - file: /etc/uwsgi/djangopypi2.ini
      - file: /var/lib/deployments/djangopypi2/media
      - module: djangopypi2_loaddata
    - require:
      - file: /etc/uwsgi/djangopypi2.ini

/etc/nginx/conf.d/djangopypi2.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://nginx/template.jinja2
    - context:
      appname: djangopypi2
      root: /var/lib/deployments/djangopypi2
      statics:
        - static
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/djangopypi2.conf
{% if salt['pillar.get']('djangopypi2:ssl', False) %}
        - cmd: /etc/ssl/{{ pillar['djangopypi2']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['djangopypi2']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['djangopypi2']['ssl'] }}/ca.crt
{% endif %}
