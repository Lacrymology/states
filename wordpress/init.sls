{#-
Wordpress: a blogging tool and content management system
=============================

Mandatory Pillar
----------------

wordpress:
  hostnames:
    - list of hostname, used for nginx config
  title: Site title
  username: admin username
  admin_password: admin's password
  email: admin email

Optional Pillar
---------------
  password:  password for mysql user "wordpress"
  public: site appear in search engines. Default is: 1 (yes)

-#}
include:
  - nginx
  - local
  - {{ salt['pillar.get']('wordpress:mysql_variant', 'mariadb') }}.server
  - php.dev
  - uwsgi.php
{%- if pillar['wordpress']['ssl']|default(False) %}
  - ssl
{%- endif %}
  - web

{%- set version = "3.5.2" %}
{%- set wordpressdir = "/usr/local/wordpress" %}
{%- set password = salt['password.pillar']('wordpress:password', 10) %}

wordpress_drop_old_db:
  mysql_database:
    - absent
    - name: wordpress
    - require:
      - service: mysql-server
      - pkg: python-mysqldb

wordpress:
  archive:
    - extracted
    - name: /usr/local/
{%- if 'files_archive' in pillar %}
    - source: {{ salt['pillar.get']('files_archive') }}/mirror/wordpress-{{ version }}.tar.gz
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
    - group: www-data
    - recurse:
      - user
      - group
    - require:
      - archive: wordpress
  mysql_database:
    - present
    - name: wordpress
    - pkg: python-mysqldb
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
      - mysql_database: wordpress_drop_old_db
  mysql_user:
    - present
    - host: localhost
    - password: {{ password }}
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_grants:
    - present
    - grant: all privileges
    - user: wordpress
    - database: wordpress.*
    - host: localhost
    - require:
      - mysql_user: wordpress
      - mysql_database: wordpress

php5-mysql:
  pkg:
    - installed
    - require:
      - pkg: php-dev

{{ wordpressdir }}/wp-config.php:
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
      - user: web
    - context:
      password: {{ password }}

wordpress_initial:
  file:
    - managed
    - name: {{ wordpressdir }}/wp-admin/init.php
    - source: salt://wordpress/init.jinja2
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - archive: wordpress
      - user: web
  cmd:
    - run
    - name: php init.php
    - cwd: {{ wordpressdir }}/wp-admin
    - user: www-data
    - require:
      - pkg: php-dev
      - pkg: php5-mysql
      - user: web
      - mysql_grants: wordpress
    - watch:
      - file: wordpress_initial
      - file: wordpress
      - file: {{ wordpressdir }}/wp-config.php
  module:
    - wait
    - grant: all privileges
    - user: wordpress
    - name: mysql.grant_add
    - database: wordpress.*
    - host: localhost
    - watch:
      - cmd: wordpress_initial

/etc/nginx/conf.d/wordpress.conf:
  file:
    - managed
    - source: salt://wordpress/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
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
    - mode: 440
    - template: jinja
    - require:
      - file: {{ wordpressdir }}/wp-config.php
      - archive: wordpress
      - pkg: php5-mysql
      - module: wordpress_initial
      - service: uwsgi_emperor
      - service: mysql-server
    - context:
      dir: {{ wordpressdir }}
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/wordpress.ini
    - require:
      - file: /etc/uwsgi/wordpress.ini
    - watch:
      - file: {{ wordpressdir }}/wp-config.php
      - archive: wordpress
      - pkg: php5-mysql

{%- if pillar['wordpress']['ssl']|default(False) %}
extend:
  nginx:
    service:
      - watch:
       - cmd: /etc/ssl/{{ pillar['wordpress']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['wordpress']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['wordpress']['ssl'] }}/ca.crt
{%- endif %}
