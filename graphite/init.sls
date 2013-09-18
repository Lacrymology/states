{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
Graphite
========

Install the web interface component of graphite

Mandatory Pillar
----------------

graphite:
  web:
    hostnames:
      - graphite.example.com
    db:
      username: psqluser
      name: psqldbname
      password: psqluserpass
    django_key: totalyrandomstring
    email:
      method: smtp
      server: smtp.example.com
      user: smtpuser
      from: from@example.com
      port: 25
      password: smtppassword
      tls: True
    sentry: http://XXX:YYY@sentry.example.com/0
    workers: 2

graphite:web:hostnames: list of HTTP hostname that ends in graphite webapp.
graphite:web:db:username: PostgreSQL username for graphite. it will be created.
graphite:web:db:name: PostgreSQL database name. it will be created.
graphite:web:db:password: PostgreSQL user password. it will be created.
graphite:web:django_key: random string.
    https://docs.djangoproject.com/en/1.4/ref/settings/#secret-key
graphite:web:email:method: smtp or amazon-ses. only smtp will be documented
    here.
graphite:web:email:server: SMTP server.
graphite:web:email:port: SMTP server port.
graphite:web:email:user: SMTP username.
graphite:web:email:from: FROM email address.
graphite:web:email:password: SMTP user password.
graphite:web:email:tls: If True, turn on SMTP encryption.
graphite:web:sentry: DSN of sentry server.
graphite:web:workers: number of uWSGI worker that will run the webapp.
message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

graphite:
  debug: False
  web:
    ssl: microsigns
    ssl_redirect: True
    render_noauth: False
    timeout: 30
    cheaper: 1
    idle: 240
graylog2_address: 192.168.1.1
shinken_pollers:
  - 192.168.1.1

graphite:web:debug: If True, graphite run with extra logging.
graphite:web:render_noauth: if set to True, the rendered graphics can be
    directly GET by anyone without user authentication.
graphite:web:ssl: Name of the SSL key to use for HTTPS.
graphite:web:ssl_redirect: if set to True and SSL is turned on, this will
    force all HTTP traffic to be redirected to HTTPS.
graphite:web:timeout: how long in seconds until a uWSGI worker is killed while
    running a single request. Default 30.
graphite:web:cheaper: number of process in uWSGI cheaper mode. Default no
    cheaper mode. See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html
graphite:web:idle: number of seconds before uWSGI switch to cheap mode.
graylog2_address: IP/Hostname of centralized Graylog2 server
shinken_pollers: IP address of monitoring poller that check this server.
-#}

{%- set python_version = '%d.%d' % (grains['pythonversion'][0], grains['pythonversion'][1]) %}

include:
  - apt
  - graphite.common
  - local
  - memcache
  - nginx
  - pip
  - postgresql
  - postgresql.server
  - python.dev
  - rsyslog
  - statsd
  - uwsgi
  - virtualenv
  - web
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
      - user: graphite
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
      - user: graphite
      - file: /etc/graphite

graphite_wsgi:
  file:
    - managed
    - name: /usr/local/graphite/lib/python{{ python_version }}/site-packages/graphite/wsgi.py
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graphite/wsgi.jinja2
    - require:
      - virtualenv: graphite
      - user: web

/usr/local/graphite/manage:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://django/manage.jinja2
    - context:
      settings: graphite.settings
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
    - upgrade: True
    - bin_env: /usr/local/graphite/bin/pip
    - requirements: /usr/local/graphite/salt-graphite-web-requirements.txt
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python{{ python_version }}/site-packages"
    - require:
      - virtualenv: graphite
    - watch:
      - file: graphite-web
      - pkg: graphite-web
      - pkg: python-dev
      - pkg: postgresql-dev
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
  pip:
    - installed
{%- if 'files_archive' in pillar %}
    - name: {{ pillar['files_archive'] }}/pip/django-decorator-include-0.1.zip
{% else %}
    - name: ""
    - editable: git+git://github.com/jeffkistler/django-decorator-include.git#egg=django-decorator-include
{% endif %}
    - bin_env: /usr/local/graphite/bin/pip
    - require:
      - module: graphite-web

graphite-urls-patch:
  file:
    - managed
    - name: /usr/local/graphite/lib/python{{ python_version }}/site-packages/graphite/urls.py
    - source: salt://graphite/urls.jinja2
    - template: jinja
    - user: www-data
    - group: graphite
    - mode: 440
    - require:
      - user: web
      - user: graphite
      - module: graphite-web

graphite_settings:
  file:
    - managed
    - name: /usr/local/graphite/lib/python{{ python_version }}/site-packages/graphite/local_settings.py
    - template: jinja
    - user: www-data
    - group: graphite
    - mode: 440
    - source: salt://graphite/config.jinja2
    - require:
      - user: web
      - user: graphite
      - module: graphite-web
  postgres_user:
    - present
    - name: {{ salt['pillar.get']('graphite:web:db:name', 'graphite') }}
    - password: {{ pillar['graphite']['web']['db']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('graphite:web:db:name', 'graphite') }}
    - owner: {{ salt['pillar.get']('graphite:web:db:username', 'graphite') }}
    - runas: postgres
    - require:
      - postgres_user: graphite_settings
      - service: postgresql
{#    - lc_collate: en_US.UTF-8#}
{#    - lc_ctype: en_US.UTF-8#}
  module:
    - wait
    - name: django.syncdb
    - settings_module: graphite.settings
    - bin_env: /usr/local/graphite
    - stateful: False
    - require:
      - postgres_database: graphite_settings
      - file: graphite_settings
      - service: rsyslog
    - watch:
      - module: graphite-web

{#-
 load default user this way to prevent race condition between uWSGI process
 #}
graphite_initial_fixture:
  file:
    - managed
    - name: /usr/local/graphite/salt-initial-fixture.xml
    - user: www-data
    - group: graphite
    - mode: 440
    - source: salt://graphite/initial-fixture.xml
    - require:
      - user: web
      - user: graphite
      - virtualenv: graphite
  module:
    - wait
    - name: django.command
    - command: loaddata /usr/local/graphite/salt-initial-fixture.xml
    - settings_module: graphite.settings
    - bin_env: /usr/local/graphite
    - stateful: False
    - require:
      - module: graphite_settings
      - file: graphite_initial_fixture
    - watch:
      - postgres_database: graphite_settings

graphite_admin_user:
  module:
    - wait
    - name: django.command
    - command: createsuperuser_plus --username={{ pillar['graphite']['web']['initial_admin_user']['username'] }} --email={{ salt['pillar.get']('graphite:web:initial_admin_user:email', 'root@example.com') }} --password={{ pillar['graphite']['web']['initial_admin_user']['password'] }}
    - settings_module: graphite.settings
    - bin_env: /usr/local/graphite
    - stateful: False
    - require:
      - module: graphite_settings
    - watch:
      - postgres_database: graphite_settings

/etc/uwsgi/graphite.ini:
  file:
    - managed
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graphite/uwsgi.jinja2
    - require:
      - module: graphite_initial_fixture
      - service: uwsgi_emperor
      - file: graphite_logdir
      - file: graphite_wsgi
      - module: graphite_settings
      - file: graphite_graph_templates
      - file: /usr/local/graphite/bin/build-index.sh
      - user: web
      - file: graphite-urls-patch
      - service: rsyslog
      - module: graphite-web
      - pip: graphite-web
      - service: memcached
  module:
    - wait
    - name: file.touch
    - require:
      - file: /etc/uwsgi/graphite.ini
      - service: memcached
    - m_name: /etc/uwsgi/graphite.ini
    - watch:
      - module: graphite_settings
      - file: graphite_wsgi
      - file: graphite_graph_templates
      - module: graphite-web
      - cmd: graphite-web
      - file: graphite-urls-patch
      - pip: graphite-web
      - module: graphite_admin_user

/usr/local/graphite/bin/build-index.sh:
  file:
    - managed
    - template: jinja
    - source: salt://graphite/build-index.jinja2
    - user: root
    - group: root
    - mode: 555
    - require:
      - virtualenv: graphite
      - file: /var/lib/graphite/whisper

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
        - file: graphite_settings
        - module: graphite-web
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/graphite.conf
{% if pillar['graphite']['web']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['graphite']['web']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['graphite']['web']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['graphite']['web']['ssl'] }}/ca.crt
{% endif %}
