{#-
Wordpress: a blogging tool and content management system
=============================

Mandatory Pillar
----------------

wordpress:
  hostnames:
    - list of hostname, used for nginx config
  password:  password for mysql user "wordpress"

Optional Pillar
---------------

-#}
include:
  - nginx
  - apt
  - local
  - {{ salt['pillar.get']('wordpress:mysql_variant', 'mariadb') }}.server
  - uwsgi.php
  - web

{% set version = "3.5.2" %}
{% set wordpressdir = "/usr/local/wordpress-" + version %}

wordpress:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/wordpress-{{ version }}.tar.gz
{%- else %}
    - source: http://wordpress.org/wordpress-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=90acae65199db7b33084ef36860d7f22
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/wordpress-{{ version }}
    - require:
      - file: /usr/local
  file:
    - managed
    - name: {{ wordpressdir }}/wp-config.php
    - template: jinja
    - source: salt://wordpress/config.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - archive: wordpress
  mysql_database:
    - present
    - name: wordpress
    - pkg: python-mysqldb
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_user:
    - present
    - host: localhost
    - password: {{ salt['pillar.get']('wordpress:password') }}
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_grants:
    - present
    - user: wordpress
    - database: wordpress.*
    - host: localhost
    - require:
      - mysql_user: wordpress
      - mysql_database: wordpress
