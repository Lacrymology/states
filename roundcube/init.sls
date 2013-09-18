{#-
RoundCube: a webmail software
=============================

Mandatory Pillar
----------------

roundcube:
  hostnames:
    - list of hostname, used for nginx config
  password:  password for postgresql user "roundcube"

Optional Pillar
---------------
-#}
include:
  - nginx
  - apt
  - local
  - postgresql.server
  - uwsgi.php
  - web

{% set version = "0.9.0" %}
{% set roundcubedir = "/usr/local/roundcubemail-" + version %}

php5-pgsql:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

roundcube:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/roundcubemail-{{ version }}.tar.gz
{%- else %}
    - source: http://jaist.dl.sourceforge.net/project/roundcubemail/roundcubemail/{{ version }}/roundcubemail-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=843de3439886c2dddb0f09e9bb6a4d04
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/roundcubemail-{{ version }}
    - require:
      - file: /usr/local
  postgres_user:
    - present
    - name: roundcube
    - password: {{ pillar['roundcube']['password'] }}
    - runas: postgres
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: roundcube
    - owner: roundcube
    - runas: postgres
    - require:
      - postgres_user: roundcube

{{ roundcubedir }}:
  file:
    - directory
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - archive: roundcube

{{ roundcubedir }}/config/db.inc.php:
  file:
    - managed
    - source: salt://roundcube/database.jinja2
    - template: jinja
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: {{ roundcubedir }}
      - archive: roundcube
      - user: web

{{ roundcubedir }}/config/main.inc.php:
  file:
    - managed
    - source: salt://roundcube/config.jinja2
    - template: jinja
    - makedirs: True
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
      - file: /etc/uwsgi/roundcube.ini
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
      - file: /etc/uwsgi/roundcube.ini
    - context:
      dir: {{ roundcubedir }}
    - watch_in:
      - service: nginx

/etc/uwsgi/roundcube.ini:
  file:
    - managed
    - source: salt://roundcube/uwsgi.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - service: uwsgi_emperor
      - module: roundcube_initial
      - file: {{ roundcubedir }}/config/main.inc.php
      - file: {{ roundcubedir }}/config/db.inc.php
      - archive: roundcube
      - pkg: php5-pgsql
    - context:
      dir: {{ roundcubedir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/roundcube.ini
    - require:
      - file: /etc/uwsgi/roundcube.ini
    - watch:
      - file: {{ roundcubedir }}/config/main.inc.php
      - file: {{ roundcubedir }}/config/db.inc.php
      - archive: roundcube
      - pkg: php5-pgsql

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
