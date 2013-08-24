{#-
Wordpress: a blogging tool and content management system
=============================

Mandatory Pillar
----------------

wordpress:
  hostnames:
    - list of hostname, used for nginx config

Optional Pillar
---------------
  password:  password for mysql user "wordpress"

-#}
include:
  - apt
  - nginx
  - local
  - {{ salt['pillar.get']('wordpress:mysql_variant', 'mariadb') }}.server
  - uwsgi.php
  - web

{%- set version = "3.5.2" %}
{%- set wordpressdir = "/usr/local/wordpress" %}
{%- set password = salt['password.pillar']('wordpress:password', 10) %}

wordpress:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
#- source: {{ salt['pillar.get']('files_archive') }}/mirror/wordpress-{{ version }}.tar.gz
    - source: http://wordpress.org/wordpress-{{ version }}.tar.gz
{%- else %}
    - source: http://wordpress.org/wordpress-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=90acae65199db7b33084ef36860d7f22
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ wordpressdir }}
    - require:
      - file: /usr/local
  file:
    - directory
    - name: {{ wordpressdir }}
    - user: www-data
    - grouP: www-data
    - recurse:
      - user
      - group
    - require:
      - archive: wordpress

      {#-  file:
    - managed
    - name: {{ wordpressdir }}/wp-config.php
    - template: jinja
    - source: salt://wordpress/config.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - archive: wordpress
      - user: web
    - context:
      password: {{ password }}
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
    - password: {{ password }}
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
      #}
/etc/nginx/conf.d/wordpress.conf:
  file:
    - managed
    - source: salt://wordpress/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 640
    - template: jinja
    - require:
      - pkg: nginx
      - file: /etc/uwsgi/wordpress.ini
    - watch_in:
      - service: nginx
    - context:
      dir: {{ wordpressdir }}

/etc/uwsgi/wordpress.ini:
  file:
    - managed
    - source: salt://wordpress/uwsgi.jinja2
    - user: www-data
    - group: www-data
    - mode: 640
    - template: jinja
    - require:
      - file: uwsgi_sockets
      - archive: wordpress
    - watch_in:
      - service: uwsgi_emperor
    - context:
      dir: {{ wordpressdir }}
