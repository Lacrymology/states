{# TODO: create initial admin user #}
include:
  - postgresql.server
  - memcache
  - virtualenv
  - nrpe
  - carbon

graphite_upstart:
  file:
    - managed
    - name: /etc/init/graphite-web.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://graphite/upstart.jinja2

graphite_logdir:
  file:
    - directory
    - name: /var/log/graphite/graphite
    - user: graphite
    - group: graphite
    - mode: 700
    - makedirs: True
    - require:
      - user: carbon

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
    - name: /usr/local/graphite
    - requirements: salt://graphite/requirements.txt
    - require:
      - pkg: python-virtualenv
      - pkg: graphite-web
      - pkg: postgresql-dev
  pkg:
    - installed
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
  service:
    - running
    - require:
      - user: carbon
      - service: postgresql
      - service: memcached
      - service: carbon
      - file: graphite_logdir
      - module: graphite-web
    - watch:
      - virtualenv: graphite-web
      - pip: graphite-web
      - file: graphite-web
      - file: graphite_upstart
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
