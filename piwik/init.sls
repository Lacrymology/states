{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set version = "2.14.3-1" %}
{%- set repo = files_archive|replace('https://', 'http://') ~ "/mirror/piwik/" ~ version
  if files_archive else "http://archive.robotinfra.com/mirror/piwik/2.14.3-1/"
%}
{%- set ssl = salt['pillar.get']('piwik:ssl', False) %}

include:
  - apt
  - mysql.server
  - nginx
  - php
  - uwsgi.php
{%- if ssl %}
  - ssl
{%- endif %}

piwik:
  pkgrepo:
    - managed
    - name: deb {{ repo }} piwik main
    - key_url: salt://piwik/key.gpg
    - file: /etc/apt/sources.list.d/piwik.list
    - clean_file: True
    - require:
      - pkg: apt_sources
  pkg:
    - latest
    - name: piwik
    - require:
      - service: mysql-server
      - pkg: php
  mysql_database:
    - present
    - name: piwik
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_user:
    - present
    - host: localhost
    - name: piwik
    - password: {{ salt["pillar.get"]("piwik:db:password") }}
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_grants:
    - present
    - grant: all privileges
    - user: piwik
    - database: piwik.*
    - host: localhost
    - require:
      - mysql_user: piwik
      - mysql_database: piwik

piwik_uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/piwik.yml
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - source: salt://uwsgi/template.jinja2
    - template: jinja
    - context:
        dir: /usr/share/piwik
        chdir: /usr/share/piwik
        appname: piwik
    - require:
      - mysql_grants: piwik
      - service: uwsgi
      - service: mysql-server
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/piwik.yml
    - require:
      - file: /etc/uwsgi/piwik.yml
    - watch:
      - file: piwik_uwsgi
      - pkg: piwik

/etc/nginx/conf.d/piwik.conf:
  file:
    - managed
    - template: jinja
    - source: salt://piwik/nginx.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - context:
        hostnames: {{ salt['pillar.get']('piwik:hostnames') }}
        ssl: {{ ssl }}
        ssl_redirect: {{ salt['pillar.get']('piwik:ssl_redirect', False) }}
    - require:
      - pkg: nginx
      - pkg: piwik
    - watch_in:
      - service: nginx

{%- if ssl %}
extend:
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
