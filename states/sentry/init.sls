{# TODO: add support for GELF logging #}

include:
  - postgresql
  - postgresql.server
  - virtualenv
  - nrpe
  - statsd
  - uwsgi
  - nginx

sentry:
  virtualenv:
    - manage
    - name: /usr/local/sentry
    - no_site_packages: True
    - requirements: salt://sentry/requirements.txt
    - require:
      - pkg: sentry
      - pkg: postgresql-dev
      - pkg: python-virtualenv
  pkg:
    - latest
    - name: libevent-dev
  file:
    - managed
    - name: /etc/sentry.conf.py
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://sentry/config.jinja2
    - require:
      - pkg: nginx
  postgres_user:
    - present
    - name: {{ pillar['sentry']['db']['username'] }}
    - password: {{ pillar['sentry']['db']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql-server
  postgres_database:
    - present
    - name: {{ pillar['sentry']['db']['name'] }}
    - owner: {{ pillar['sentry']['db']['username'] }}
    - runas: postgres
    - require:
      - postgres_user: sentry
      - service: postgresql-server
  cmd:
    - wait
    - stateful: False
    - user: www-data
    - group: www-data
    - name: /usr/local/sentry/bin/sentry --config=/etc/sentry.conf.py upgrade --noinput
    - require:
      - postgres_user: sentry
      - service: postgresql-server
    - watch:
      - virtualenv: sentry
      - file: sentry

/etc/uwsgi/sentry.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://sentry/uwsgi.jinja2
    - require:
      - service: uwsgi_emperor
      - cmd: sentry
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/sentry.ini
    - require:
      - file: /etc/uwsgi/sentry.ini
    - watch:
      - file: sentry
      - virtualenv: sentry

/etc/nagios/nrpe.d/sentry.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://sentry/nrpe.jinja2

/etc/nginx/conf.d/sentry.conf:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://sentry/nginx.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/sentry.cfg
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/sentry.conf
