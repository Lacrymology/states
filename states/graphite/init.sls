{# TODO: create initial admin user #}
{# TODO: send logs straight to GELF #}
include:
  - postgresql.server
  - memcache
  - virtualenv
  - nrpe
  - carbon
  - uwsgi
  - nginx

{#graphite_logrotate:#}
{#  file:#}
{#    - managed#}
{#    - name: /etc/logrotate.d/graphite-web#}
{#    - template: jinja#}
{#    - user: root#}
{#    - group: root#}
{#    - mode: 600#}
{#    - source: salt://graphite/logrotate.jinja2#}

graphite_root_logdir:
  file:
    - directory
    - name: /var/log/graphite
    - user: root
    - group: root
    - mode: 775
    - makedirs: True

graphite_logdir:
  file:
    - directory
    - name: /var/log/graphite/graphite
    - user: www-data
    - group: www-data
    - mode: 770
    - makedirs: True
    - require:
      - user: carbon
      - file: graphite_root_logdir

graphite_graph_templates:
  file:
    - managed
    - name: /etc/graphite/graphTemplates.conf
    - template: jinja
    - user: graphite
    - group: graphite
    - mode: 600
    - source: salt://graphite/graph_templates.jinja2
    - require:
      - user: carbon

graphite_wsgi:
  file:
    - managed
    - name: /usr/local/graphite/lib/python2.7/site-packages/graphite/wsgi.py
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://graphite/wsgi.jinja2
    - require:
      - virtualenv: graphite-web

{#graphite_admin_user:#}
{#  module:#}
{#    - run#}
{#    - name: django.loaddata#}
{#    - fixtures: {{ opts['cache_dir']/graphite.yaml }}#}
{#    - settings_module: graphite.local_settings#}
{#    - bin_env: /usr/local/graphite#}

graphite-web:
  virtualenv:
    - manage
    - name: /usr/local/graphite/
    - requirements: salt://graphite/requirements.txt
    - require:
      - pkg: python-virtualenv
      - pkg: graphite-web
      - pkg: postgresql-dev
  pkg:
    - latest
    - name: libcairo2-dev
  pip:
    - installed
    - bin_env: /usr/local/graphite/bin/pip
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python2.7/site-packages"
    - require:
      - virtualenv: graphite-web
  file:
    - managed
    - name: /usr/local/graphite/lib/python2.7/site-packages/graphite/local_settings.py
    - template: jinja
    - user: graphite
    - group: graphite
    - mode: 600
    - source: salt://graphite/config.jinja2
    - require:
      - user: carbon
  postgres_user:
    - present
    - name: {{ pillar['graphite']['web']['db']['name'] }}
    - password: {{ pillar['graphite']['web']['db']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ pillar['graphite']['web']['db']['name'] }}
    - owner: {{ pillar['graphite']['web']['db']['username'] }}
    - runas: postgres
    - require:
      - postgres_user: graphite-web
      - service: postgresql
  module:
    - run
    - name: django.syncdb
    - settings_module: graphite.local_settings
    - bin_env: /usr/local/graphite

graphite_uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/graphite.ini
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 600
    - source: salt://graphite/uwsgi.jinja2
    - require:
      - service: uwsgi_emperor
      - user: carbon
      - service: postgresql
      - service: memcached
      - service: carbon
      - file: graphite_logdir
      - module: graphite-web
{#    - watch:#}
      - virtualenv: graphite-web
      - pip: graphite-web
      - file: graphite-web
      - postgres_user: graphite-web
      - postgres_database: graphite-web
      - file: graphite_graph_templates

/etc/nagios/nrpe.d/graphite.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://graphite/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graphite.cfg
