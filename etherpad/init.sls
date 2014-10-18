{#-
Copyright (c) 2014, Dang Tung Lam
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

Author: Dang Tung Lam <lamdt@familug.org>
Maintainer: Dang Tung Lam <lamdt@familug.org>

Installing Etherpad - Real-time document editing
-#}
{%- from 'upstart/rsyslog.sls' import manage_upstart_log with context -%}
include:
  - apt
  - debian.package_build
  - nginx
  - nodejs
  - local
  - postgresql.server
  - python.dev
  - rsyslog
{%- if salt['pillar.get']('etherpad:ssl', False) %}
  - ssl
{%- endif %}
{#- Etherpad depends on libssl-dev #}
  - ssl.dev
  - web

{%- set version = "1.3.0" %}
{%- set web_root_dir = "/usr/local/etherpad-lite-" + version %}

etherpad-dependencies:
  pkg:
    - installed
    - pkgs:
      - curl
      - pkg-config
    - require:
      - pkg: package_build
      - pkg: ssl-dev
      - pkg: nodejs
      - pkg: python-dev
      - cmd: apt_sources

{%- set dbuser = salt['pillar.get']('etherpad:db:username', 'etherpad') %}
{%- set dbuserpass = salt['password.pillar']('etherpad:db:password', 10) %}
{%- set dbhost = salt['pillar.get']('etherpad:db:host', 'localhost') %}
{%- set dbname = salt['pillar.get']('etherpad:db:name', 'etherpad') %}

{{ web_root_dir }}:
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
      - user: web
      - archive: etherpad
      - pkg: etherpad-dependencies

etherpad:
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
      - postgres_user: etherpad
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/etherpad-lite-{{ version }}.tar.gz
{%- else %}
    - source: https://github.com/ether/etherpad-lite/archive/{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=baa4e7c8588cfcf5c2a4ef7768de5e89
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: /etc/init/etherpad.conf
    - source: salt://etherpad/upstart.jinja2
    - template: jinja
    - mode: 440
    - context:
      web_root_dir: {{ web_root_dir }}
      user: www-data
  service:
    - running
    - order: 50
    - enable: True
    - require:
      - file: {{ web_root_dir }}
      - file: {{ web_root_dir }}/bin
      - postgres_database: etherpad
    - watch:
      - user: web
      - file: {{ web_root_dir }}/APIKEY.txt
      - file: {{ web_root_dir }}/settings.json
      - file: etherpad

{{ manage_upstart_log('etherpad') }}

{{ web_root_dir }}/bin:
  file:
    - directory
    - file_mode: 550
    - recurse:
      - mode
    - require:
      - file: {{ web_root_dir }}

{{ web_root_dir }}/APIKEY.txt:
  file:
    - managed
    - user: www-data
    - group: www-data
    - mode: 400
    - source: salt://etherpad/api.jinja2
    - template: jinja
    - require:
      - file: {{ web_root_dir }}
      - user: web

{{ web_root_dir }}/settings.json:
  file:
    - managed
    - user: www-data
    - group: www-data
    - mode: 640
    - source: salt://etherpad/settings.jinja2
    - template: jinja
    - context:
      dbuser: {{ dbuser }}
      dbuserpass: {{ dbuserpass }}
      dbname: {{ dbname }}
      dbhost: {{ dbhost }}
    - require:
      - file: {{ web_root_dir }}
      - user: web

/etc/nginx/conf.d/etherpad.conf:
  file:
    - managed
    - source: salt://etherpad/nginx.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - service: etherpad

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/etherpad.conf
{%- if salt['pillar.get']('etherpad:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['etherpad']['ssl'] }}
{%- endif %}
