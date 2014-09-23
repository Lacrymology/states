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
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Install the web interface component of graphite.
-#}

{%- set python_version = '%d.%d' % (grains['pythonversion'][0], grains['pythonversion'][1]) %}

include:
  - apt
  - bash
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
  - sudo
  - uwsgi
  - virtualenv
  - web
{% if salt['pillar.get']('graphite:ssl', False) %}
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
      - cmd: graphite-web

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
      - pkg: sudo
      - file: bash

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/graphite/salt-graphite-web-requirements.txt:
  file:
    - absent

graphite-web:
  file:
    - managed
    - name: /usr/local/graphite/salt-graphite-requirements.txt
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
    - requirements: /usr/local/graphite/salt-graphite-requirements.txt
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python{{ python_version }}/site-packages"
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
    - name: django-decorator-include==0.1
{% else %}
    - name: ""
    - editable: git+git://github.com/jeffkistler/django-decorator-include.git#egg=django-decorator-include
{% endif %}
    - bin_env: /usr/local/graphite/bin/pip
    - require:
      - module: graphite-web

graphite-web-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/graphite.yml
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graphite/uwsgi.jinja2
    - require:
      - module: graphite_initial_fixture
      - file: graphite_logdir
      - file: /usr/local/graphite/bin/build-index.sh
      - user: web
      - service: rsyslog
      - service: memcached
      - user: graphite
      - module: graphite_settings
      - file: graphite_wsgi
      - file: graphite_graph_templates
      - module: graphite-web
      - cmd: graphite-web
      - file: graphite-urls-patch
      - pip: graphite-web
      - module: graphite_admin_user
      - service: uwsgi_emperor

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
    - name: {{ salt['pillar.get']('graphite:db:username', 'graphite') }}
    - password: {{ salt['password.pillar']('graphite:db:password', 10) }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('graphite:db:name', 'graphite') }}
    - owner: {{ salt['pillar.get']('graphite:db:username', 'graphite') }}
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
    - command: createsuperuser_plus --username={{ pillar['graphite']['initial_admin_user']['username'] }} --email={{ salt['pillar.get']('graphite:initial_admin_user:email', 'root@example.com') }} --password={{ pillar['graphite']['initial_admin_user']['password'] }}
    - settings_module: graphite.settings
    - bin_env: /usr/local/graphite
    - stateful: False
    - require:
      - module: graphite_settings
    - watch:
      - postgres_database: graphite_settings

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
      - file: bash

/etc/nginx/conf.d/graphite.conf:
  file:
    - managed
    - template: jinja
    - source: salt://graphite/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: graphite-web-uwsgi
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
        - user: graphite
{% if salt['pillar.get']('graphite:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['graphite']['ssl'] }}
{% endif %}
