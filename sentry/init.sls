{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Install a Sentry (error management and reporting tool) web server.
-#}
include:
  - apt
  - bash
  - local
  - nginx
  - pip
  - postgresql
  - postgresql.server
  - python.dev
  - memcache
  - rsyslog
{% if salt['pillar.get']('sentry:ssl', False) %}
  - ssl
{% endif %}
{% if 'graphite_address' in pillar %}
  - statsd
{% endif %}
  - sudo
  - uwsgi
  - virtualenv
  - web

sentry:
  virtualenv:
    - manage
    - name: /usr/local/sentry
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
  pkg:
    - latest
    - name: libevent-dev
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /usr/local/sentry/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://sentry/requirements.jinja2
    - require:
      - virtualenv: sentry
      - pkg: sentry
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/sentry/bin/pip
    - requirements: /usr/local/sentry/salt-requirements.txt
    - require:
      - virtualenv: sentry
    - watch:
      - pkg: sentry
      - pkg: python-dev
      - pkg: postgresql-dev
      - file: sentry
  cmd:
    - wait
    - name: find /usr/local/sentry -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: sentry
  postgres_user:
    - present
    - name: {{ salt['pillar.get']('sentry:db:username', 'sentry') }}
    - password: {{ salt['password.pillar']('sentry:db:password', 10) }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('sentry:db:name', 'sentry') }}
    - owner: {{ salt['pillar.get']('sentry:db:username', 'sentry') }}
    - runas: postgres
    - require:
      - postgres_user: sentry
      - service: postgresql

sentry-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/sentry.yml
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://sentry/uwsgi.jinja2
    - context:
      appname: sentry
      module: sentry.wsgi
      virtualenv: /usr/local/sentry
      chdir: /usr/local/sentry
    - require:
      - service: memcached
      - service: uwsgi_emperor
      - service: rsyslog
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/sentry.yml
    - require:
      - file: /etc/uwsgi/sentry.yml
    - watch:
      - file: sentry
      - cmd: sentry_settings
      - file: /var/lib/deployments/sentry

sentry_settings:
  file:
    - managed
    - name: /etc/sentry.conf.py
    - template: jinja
    - user: www-data
    - group: www-data
    - require:
      - user: web
    - mode: 440
    - source: salt://sentry/config.jinja2
  cmd:
    - wait
    - stateful: False
    - user: www-data
    - group: www-data
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py upgrade --noinput
    - require:
      - cmd: sentry-migrate-fake
      - module: sentry
      - postgres_database: sentry
      - user: web
    - watch:
      - module: sentry
      - file: sentry_settings

/usr/local/sentry/manage:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://django/manage.jinja2
    - context:
      alternate_admin_cmd: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py
    - require:
      - virtualenv: sentry
      - pkg: sudo
      - file: bash

sentry-syncdb-all:
  cmd:
    - wait
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py syncdb --all --noinput
    - stateful: False
    - require:
      - module: sentry
      - file: sentry_settings
      - service: rsyslog
    - watch:
      - postgres_database: sentry

sentry_admin_user:
  cmd:
    - wait
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py createsuperuser_plus --username={{ pillar['sentry']['initial_admin_user']['username'] }} --email={{ pillar['sentry']['initial_admin_user']['email'] }} --password={{ pillar['sentry']['initial_admin_user']['password'] }}
    - require:
      - cmd: sentry-syncdb-all
    - watch:
      - postgres_database: sentry

sentry-migrate-fake:
  cmd:
    - wait
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py migrate --fake --noinput
    - stateful: False
    - watch:
      - cmd: sentry-syncdb-all

/etc/nginx/conf.d/sentry.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://sentry/nginx.jinja2
    - require:
      - pkg: nginx
      - file: sentry-uwsgi
      - file: /var/lib/deployments/sentry

/var/lib/deployments/sentry:
    file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 750
    - recurse:
      - user
      - group
    - require:
      - file: web
      - file: sentry-uwsgi

sentry_collectstatic:
  module:
    - wait
    - name: django.collectstatic
    - settings_module: sentry.conf.server
    - bin_env: /usr/local/sentry
    - env:
        SENTRY_CONF: /etc/sentry.conf.py
    - require:
      - cmd: sentry_settings
      - cmd: sentry
    - watch:
      - file: sentry_settings
      - module: sentry

extend:
  memcached:
    service:
      - watch:
        - module: sentry
        - cmd: sentry_settings
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/sentry.conf
{% if salt['pillar.get']('sentry:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['sentry']['ssl'] }}
{% endif %}
