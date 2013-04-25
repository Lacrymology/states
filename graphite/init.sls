{#
 Install the web interface component of graphite
 #}
{# TODO: create initial admin user #}
include:
  - postgresql.server
  - virtualenv
  - graphite.common
  - uwsgi
  - nginx
  - memcache
  - pip
  - web
  - apt
{% if pillar['graphite']['web']['ssl']|default(False) %}
  - ssl
{% endif %}

{#graphite_logrotate:#}
{#  file:#}
{#    - managed#}
{#    - name: /etc/logrotate.d/graphite-web#}
{#    - template: jinja#}
{#    - user: root#}
{#    - group: root#}
{#    - mode: 600#}
{#    - source: salt://graphite/logrotate.jinja2#}

graphite_logdir:
  file:
    - directory
    - name: /var/log/graphite/graphite
    - user: www-data
    - group: graphite
    - mode: 770
    - makedirs: True
    - require:
      - user: web
      - group: graphite
      - file: /var/log/graphite

graphite_graph_templates:
  file:
    - managed
    - name: /etc/graphite/graphTemplates.conf
    - template: jinja
    - user: www-data
    - group: graphite
    - mode: 440
    - source: salt://graphite/graph_templates.jinja2
    - require:
      - user: web
      - group: graphite

graphite_wsgi:
  file:
    - managed
    - name: /usr/local/graphite/lib/python2.7/site-packages/graphite/wsgi.py
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graphite/wsgi.jinja2
    - require:
      - virtualenv: graphite
      - user: web

{#graphite_admin_user:#}
{#  module:#}
{#    - run#}
{#    - name: django.loaddata#}
{#    - fixtures: {{ opts['cache_dir']/graphite.yaml }}#}
{#    - settings_module: graphite.local_settings#}
{#    - bin_env: /usr/local/graphite#}

/usr/local/graphite/manage:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://django/manage.jinja2
    - context:
      settings: graphite.local_settings
      virtualenv: /usr/local/graphite
    - require:
      - virtualenv: graphite

graphite-web:
  file:
    - managed
    - name: /usr/local/graphite/salt-graphite-web-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://graphite/requirements.jinja2
    - require:
      - virtualenv: graphite
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - bin_env: /usr/local/graphite/bin/pip
    - requirements: /usr/local/graphite/salt-graphite-web-requirements.txt
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python2.7/site-packages"
    - watch:
      - file: graphite-web
    - require:
      - pkg: graphite-web
      - virtualenv: graphite
  pkg:
    - installed
    - name: libcairo2-dev
    - require:
      - cmd: apt_sources
  cmd:
    - wait
    - name: find /usr/local/graphite -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: graphite-web
{#
  pip:
    - installed
    - editable: git+git://github.com/jeffkistler/django-decorator-include.git#egg=django-decorator-include
    - bin_env: /usr/local/graphite/bin/pip
    - require:
      - file: pip-cache
#}

graphite-urls-patch:
  file:
    - managed
    - name: /usr/local/graphite/lib/python2.7/site-packages/graphite/urls.py
    - source: salt://graphite/urls.jinja2
    - template: jinja
    - user: www-data
    - group: graphite
    - mode: 440
    - require:
      - user: web
      - group: graphite
      - module: graphite-web

graphite_settings:
  file:
    - managed
    - name: /usr/local/graphite/lib/python2.7/site-packages/graphite/local_settings.py
    - template: jinja
    - user: www-data
    - group: graphite
    - mode: 440
    - source: salt://graphite/config.jinja2
    - require:
      - user: web
      - group: graphite
      - module: graphite-web
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
      - postgres_user: graphite_settings
      - service: postgresql
{#    - lc_collate: en_US.UTF-8#}
{#    - lc_ctype: en_US.UTF-8#}
  module:
    - wait
    - name: django.syncdb
    - settings_module: graphite.local_settings
    - bin_env: /usr/local/graphite
    - stateful: False
    - require:
      - postgres_database: graphite_settings
      - file: graphite_settings
    - watch:
      - module: graphite-web

/etc/uwsgi/graphite.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graphite/uwsgi.jinja2
    - require:
      - service: uwsgi_emperor
      - file: graphite_logdir
      - module: graphite_settings
      - file: /usr/local/graphite/bin/build-index.sh
      - user: web
  module:
    - wait
    - name: file.touch
    - require:
      - file: /etc/uwsgi/graphite.ini
    - m_name: /etc/uwsgi/graphite.ini
    - watch:
      - module: graphite_settings
      - file: graphite_wsgi
      - file: graphite_graph_templates
      - module: graphite-web
      - cmd: graphite-web
      - file: graphite-urls-patch

/usr/local/graphite/bin/build-index.sh:
  file:
    - managed
    - template: jinja
    - source: salt://graphite/build-index.jinja2
    - user: root
    - group: root
    - mode: 555

/etc/nginx/conf.d/graphite.conf:
  file:
    - managed
    - template: jinja
    - source: salt://graphite/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - module: /etc/uwsgi/graphite.ini
      - pkg: nginx

extend:
  memcached:
    service:
      - watch:
        - module: graphite_settings
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/graphite.conf
{% if pillar['graphite']['web']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['graphite']['web']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['graphite']['web']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['graphite']['web']['ssl'] }}/ca.crt
{% endif %}
