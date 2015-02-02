{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Install a Sentry (error management and reporting tool) web server.
-#}
{%- set ssl = salt['pillar.get']('sentry:ssl', False) %}

include:
  - apt
  - bash
  - local
  - nginx
  - pip
  - postgresql.server
  - python.dev
  - memcache
  - rsyslog
{% if ssl %}
  - ssl
{% endif %}
{% if salt['pillar.get']('graphite_address', False) %}
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
    - watch_in:
      - service: memcached
  cmd:
    - wait
    - name: find /usr/local/sentry -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: sentry
  postgres_user:
    - present
{%- set username = salt['pillar.get']('sentry:db:username', 'sentry') %}
    - name: {{ username }}
    - password: {{ salt['password.pillar']('sentry:db:password', 10) }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('sentry:db:name', 'sentry') }}
    - owner: {{ username }}
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
      - service: uwsgi
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
    - watch_in:
      - service: memcached

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
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py createsuperuser_plus --username={{ salt['pillar.get']('sentry:initial_admin_user:username') }} --email={{ salt['pillar.get']('sentry:initial_admin_user:email') }} --password={{ salt['pillar.get']('sentry:initial_admin_user:password') }}
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
    - user: root
    - group: www-data
    - mode: 440
    - source: salt://sentry/nginx.jinja2
    - require:
      - pkg: nginx
      - file: sentry-uwsgi
      - file: /var/lib/deployments/sentry
    - watch_in:
      - service: nginx

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

{% if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
