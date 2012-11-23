include:
  - postgresql
  - postgresql.server
  - virtualenv
  - nrpe
  - statsd

sentry_upstart:
  file:
    - managed
    - name: /etc/init/sentry.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://sentry/upstart.jinja2

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
    - installed
    - name: libevent-dev
  file:
    - managed
    - name: /etc/sentry.conf.py
    - template: jinja
    - user: nobody
    - group: nogroup
    - mode: 600
    - source: salt://sentry/config.jinja2
    - require:
      - virtualenv: sentry
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
  service:
    - running
    - require:
      - service: postgresql-server
    - watch:
      - virtualenv: sentry
      - file: sentry
      - file: sentry_upstart
      - postgres_user: sentry
      - postgres_database: sentry
{% if pillar['sentry']['email']['method'] == "amazon_ses" %}
    - require:
      - pip: sentry
  pip:
    - installed
    - names:
      - boto
      - django-ses
    - require:
      - virtualenv: sentry
{% endif %}

/etc/nagios/nrpe.d/sentry.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://sentry/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/sentry.cfg
