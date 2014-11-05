{#-
Copyright (c) 2013, Lam Dang Tung
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

Author: Lam Dang Tung <lam@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - build
  - openldap.dev
  - nginx
  - pip
  - postgresql.server
  - python.dev
  - python.pillow
  - rsyslog
{%- if salt['pillar.get']('openerp:ssl', False) %}
  - ssl
{%- endif %}
  - ssl.dev
  - underscore
  - uwsgi
  - virtualenv
  - web
  - xml
  - yaml

{%- set home = "/usr/local/openerp" %}
{%- set filename = "openerp-7.0-20130909-231057" %}
{%- set web_root_dir =  home +"/"+ filename %}
{%- set password = salt['password.pillar']('openerp:db:password', 10)  %}
{%- set username = salt['pillar.get']('openerp:db:username', 'openerp') %}

{#- TODO: remove that statement in >= 2014-04 #}
{%- for prefix in ('salt', 'salt-openerp') %}
{{ home }}/{{ prefix }}-requirements.txt:
  file:
    - absent
{%- endfor %}

openerp_depends:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/openerp
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openerp/requirements.jinja2
    - require:
      - file: /usr/local
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: {{ home }}/bin/pip
    - requirements: {{ opts['cachedir'] }}/pip/openerp
    - install_options:
      - "--prefix={{ home }}"
      - "--install-lib={{ home }}/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/site-packages"
    - require:
      - virtualenv: openerp
    - watch:
      - file: openerp_depends
      - pkg: ssl-dev
      - pkg: python-dev
      - pkg: ldap-dev
      - pkg: postgresql-dev
      - pkg: build
      - pkg: libjs-underscore
      - pkg: xml-dev
      - pkg: yaml
      - pkg: pillow-dependencies
  cmd:
    - wait
    - name: find {{ home }} -name '*.pyc' -delete
    - stateful: False
    - user: root
    - watch:
      - module: openerp_depends

{{ web_root_dir }}:
  file:
    - directory
    - user: root
    - group: openerp
    - mode: 750
    - require:
      - archive: openerp
      - user: openerp
      - cmd: openerp_depends
  cmd:
    - wait
    - name: chown -R root:openerp {{ web_root_dir }} && chmod -R u=rwX,g=rX,o= {{ web_root_dir }}
    - watch:
      - file: {{ web_root_dir }}
      - user: openerp

openerp:
  user:
    - present
    - shell: /bin/false
    - home: {{ home }}
    - groups:
      - www-data
    - require:
      - file: /usr/local
      - group: web
  virtualenv:
    - managed
    - name: {{ home }}
    - require:
      - user: openerp
      - module: virtualenv
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ password }}
    - createdb: True
    - require:
      - service: postgresql
  file:
    - name: /etc/init/openerp.conf
{%- if salt['pillar.get']('openerp:company_db', False) %}
    - managed
    - source: salt://openerp/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - context:
      home: {{ web_root_dir }}
    - require:
      - file: {{ web_root_dir }}/openerp-cron.py
{%- else %}
    - absent
{%- endif %}
  archive:
    - extracted
    - name: {{ home }}/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/openerp/{{ filename }}.tar.gz
{%- else %}
    - source: http://nightly.openerp.com/7.0/nightly/src/{{ filename }}.tar.gz
{%- endif %}
    - source_hash: md5=0e139452d2f0bcd8f09b0a494b3ac839
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  service:
    - name: openerp
{%- if salt['pillar.get']('openerp:company_db', False) %}
    - running
    - watch:
      - user: openerp
      - file: openerp
    - require:
      - file: {{ home }}/config.yaml
{%- else %}
    - dead
{%- endif %}
{#- does not use PID, no need to manage #}

{{ manage_upstart_log('openerp') }}

openerp-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/openerp.yml
    - template: jinja
    - source: salt://uwsgi/template.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - context:
      appname: openerp
      chdir: {{ web_root_dir }}/openerp
      uid: openerp
      gid: openerp
      wsgi_file: {{ web_root_dir }}/openerp.wsgi
      virtualenv: {{ home }}
    - require:
      - service: uwsgi
      - postgres_user: openerp
      - cmd: {{ web_root_dir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/openerp.yml
    - require:
      - file: /etc/uwsgi/openerp.yml
    - watch:
      - user: openerp
      - module: openerp_depends
      - archive: openerp
      - file: {{ web_root_dir }}/openerp.wsgi
      - cmd: openerp_depends

{{ web_root_dir }}/openerp.wsgi:
  file:
    - managed
    - user: openerp
    - group: openerp
    - mode: 440
    - source: salt://openerp/wsgi.py
    - require:
      - cmd: {{ web_root_dir }}
      - file: {{ home }}/config.yaml

{{ web_root_dir }}/openerp-cron.py:
  file:
{%- if salt['pillar.get']('openerp:company_db', False) %}
    - managed
    - user: openerp
    - group: openerp
    - mode: 550
    - source: salt://openerp/cron.py
    - require:
      - cmd: {{ web_root_dir }}
      - file: {{ home }}/config.yaml
{%- else %}
    - absent
{%- endif %}

{{ home }}/config.yaml:
  file:
    - managed
    - user: openerp
    - group: openerp
    - source: salt://openerp/config.jinja2
    - template: jinja
    - mode: 440
    - require:
      - cmd: {{ web_root_dir }}
    - context:
      password: {{ password }}
      username: {{ username }}
      sentry_dsn: {{ salt['pillar.get']('openerp:sentry_dsn', False) }}
      process_name: openerp

/etc/nginx/conf.d/openerp.conf:
  file:
    - managed
    - source: salt://openerp/nginx.jinja2
    - template: jinja
    - group: www-data
    - user: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - file: openerp-uwsgi
{%- if salt['pillar.get']('openerp:ssl', False) %}
      - cmd: ssl_cert_and_key_for_{{ pillar['openerp']['ssl'] }}
{%- endif %}
    - watch_in:
      - service: nginx
    - context:
      web_root_dir: {{ web_root_dir }}

extend:
  web:
    user:
      - groups:
        - openerp
      - require:
        - user: openerp
      - watch_in:
        - file: openerp-uwsgi
