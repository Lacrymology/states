{#
 Install a Sentry (error management and reporting tool) web server.

 Once this state is installed, you need to create initial admin user:

 /usr/local/sentry/manage createsuperuser

 #}
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
{% if pillar['sentry']['ssl']|default(False) %}
  - ssl
{% endif %}
{% if 'graphite_address' in pillar %}
  - statsd
{% endif %}

sentry:
  virtualenv:
    - manage
    - name: /usr/local/sentry
    - no_site_packages: True
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
    - password: {{ pillar['sentry']['db']['password'] }}
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
    - source: salt://sentry/manage.jinja2
    - require:
      - virtualenv: sentry

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
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py createsuperuser_plus --username={{ pillar['sentry']['initial_admin_user']['username'] }} --email={{ salt['pillar.get']('sentry:initial_admin_user:email', 'root@example.com') }} --password={{ pillar['sentry']['initial_admin_user']['password'] }}
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

/etc/uwsgi/sentry.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://sentry/uwsgi.jinja2
    - require:
      - service: memcached
      - service: uwsgi_emperor
      - cmd: sentry_settings
      - service: rsyslog
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/sentry.ini
    - require:
      - file: /etc/uwsgi/sentry.ini
    - watch:
      - file: sentry
      - cmd: sentry_settings

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
{% if pillar['sentry']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['sentry']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['sentry']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['sentry']['ssl'] }}/ca.crt
{% endif %}
