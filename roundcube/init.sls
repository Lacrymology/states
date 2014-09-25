{#-
Copyright (c) 2013, Hung Nguyen Viet
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

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

A webmail software.
-#}
include:
  - local
  - nginx
  - php.dev
  - postgresql.server
  - uwsgi.php
{%- if salt['pillar.get']('roundcube:ssl', False) %}
  - ssl
{%- endif %}
  - web

{%- set version = "1.0.1" %}
{%- set roundcubedir = "/usr/local/roundcubemail-" + version %}
{%- set dbname = salt['pillar.get']('roundcube:db:name', 'roundcube') %}
{%- set dbuser = salt['pillar.get']('roundcube:db:username', 'roundcube') %}
{%- set dbuserpass = salt['password.pillar']('roundcube:db:password', 10) %}

php5-pgsql:
  pkg:
    - installed
    - require:
      - pkg: php-dev

roundcube:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/roundcubemail-{{ version }}.tar.gz
{%- else %}
    - source: http://jaist.dl.sourceforge.net/project/roundcubemail/roundcubemail/{{ version }}/roundcubemail-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=2e1629ea21615005b0a991e591f36363
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/roundcubemail-{{ version }}
    - require:
      - file: /usr/local
  postgres_user:
    - present
    - name: {{ dbuser }}
    - password: {{ dbuserpass }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ dbname }}
    - owner: {{ dbuser }}
    - runas: postgres
    - require:
      - postgres_user: roundcube

roundcube-uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/roundcube.yml
    - source: salt://uwsgi/template.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - context:
      appname: roundcube
      chdir: {{ roundcubedir }}
    - require:
      - service: uwsgi_emperor
      - module: roundcube_initial
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/roundcube.yml
    - require:
      - file: /etc/uwsgi/roundcube.yml
    - watch:
      - file: {{ roundcubedir }}/config/config.inc.php
      - archive: roundcube
      - pkg: php5-pgsql
      - pkg: roundcube_password_plugin_ldap_driver_dependency

{{ roundcubedir }}:
  file:
    - directory
    - user: www-data
    - group: www-data
    - dir_mode: 750
    - file_mode: 640
    - recurse:
      - user
      - group
    - require:
      - archive: roundcube
      - user: web

{{ roundcubedir }}/installer:
  file:
    - absent
    - require:
      - archive: roundcube

{{ roundcubedir }}/bin:
  file:
    - directory
    - user: www-data
    - mode: 550
    - recurse:
      - mode
    - require:
      - file: {{ roundcubedir }}

{{ roundcubedir }}/config/db.inc.php:
  file:
    - absent

{{ roundcubedir }}/config/main.inc.php:
  file:
    - absent

{{ roundcubedir }}/config/config.inc.php:
  file:
    - managed
    - source: salt://roundcube/config.jinja2
    - template: jinja
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 440
    - context:
      password: {{ dbuserpass }}
      dbname: {{ dbname }}
      username: {{ dbuser }}
    - require:
      - file: {{ roundcubedir }}
      - user: web
      - archive: roundcube
      - file: {{ roundcubedir }}/config/main.inc.php
      - file: {{ roundcubedir }}/config/db.inc.php

roundcube_password_plugin_ldap_driver_dependency:
  pkg:
    - installed
    - name: php-net-ldap2

{{ roundcubedir }}/plugins/password/config.inc.php:
  file:
    - managed
    - source: salt://roundcube/password_plugin.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: {{ roundcubedir }}
      - user: web
      - archive: roundcube
      - pkg: roundcube_password_plugin_ldap_driver_dependency

{{ roundcubedir }}/plugins/managesieve/config.inc.php:
  file:
    - managed
    - source: salt://roundcube/sieve_plugin.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: {{ roundcubedir }}
      - user: web
      - archive: roundcube

{% for dir in ('logs', 'temp') %}
{{ roundcubedir }}/{{ dir }}:
  file:
    - directory
    - user: www-data
    - recurse:
      - user
    - require:
      - file: {{ roundcubedir }}
      - user: web
    - require_in:
      - file: roundcube-uwsgi
{% endfor %}

/etc/nginx/conf.d/roundcube.conf:
  file:
    - managed
    - source: salt://roundcube/nginx.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - user: web
      - file: roundcube-uwsgi
    - context:
      dir: {{ roundcubedir }}

roundcube_initial:
  cmd:
    - wait
    - name: psql -f {{ roundcubedir }}/SQL/postgres.initial.sql -d roundcube
    - user: postgres
    - group: postgres
    - require:
      - service: postgresql
      - postgres_database: roundcube
    - watch:
      - archive: roundcube
  module:
    - wait
    - name: postgres.owner_to
    - dbname: roundcube
    - ownername: roundcube
    - runas: postgres
    - watch:
      - cmd: roundcube_initial

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/roundcube.conf
{%- if salt['pillar.get']('roundcube:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['roundcube']['ssl'] }}
{% endif %}
