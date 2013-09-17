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
{% if pillar['djangopypi2']['ssl']|default(False) %}
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
    - password: {{ pillar['djangopypi2']['db']['password'] }}
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

djangopypi2_collectstatic:
  module:
    - wait
    - name: django.collectstatic
    - settings_module: djangopypi2.website.settings
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2_settings
    - watch:
      - file: djangopypi2_settings
      - file: djangopypi2_urls

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
      - module: djangopypi2_collectstatic

djangopypi2_admin_user:
  module:
    - wait
    - name: django.command
    - command: createsuperuser_plus --username={{ pillar['djangopypi2']['web']['initial_admin_user']['username'] }} --email={{ salt['pillar.get']('djangopypi2:web:initial_admin_user:email', 'root@example.com') }} --password={{ pillar['djangopypi2']['web']['initial_admin_user']['password'] }}
    - settings_module: djangopypi2.website.settings
    - bin_env: {{ root_dir }}
    - require:
      - module: djangopypi2_loaddata
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
      - service: uwsgi_emperor
      - postgres_database: djangopypi2
      - service: memcached

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
{% if pillar['djangopypi2']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['djangopypi2']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['djangopypi2']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['djangopypi2']['ssl'] }}/ca.crt
{% endif %}
