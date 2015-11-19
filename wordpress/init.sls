{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('wordpress:ssl', False) %}

include:
  - local
  - nginx
  - logrotate
  - mysql.server
  - php.dev
{%- if ssl %}
  - ssl
{%- endif %}
  - uwsgi.php
  - web

{%- set version = "4.2.2" %}
{%- set wordpressdir = "/usr/local/wordpress" %}
{%- set dbuser = salt['pillar.get']('wordpress:db:username', 'wordpress') %}
{%- set dbuserpass = salt['password.pillar']('wordpress:db:password', 10) %}
{%- set dbname = salt['pillar.get']('wordpress:db:name', 'wordpress') %}

wordpress:
  archive:
    - extracted
    - name: /usr/local/
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/wordpress-{{ version }}.tar.gz
{%- else %}
    - source: http://wordpress.org/wordpress-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=c40d56cf85975482d5f5fa8c4b97d1d2
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
    - mode: 750
    - recurse:
      - user
      - group
    - require:
      - archive: wordpress
  mysql_database:
    - present
    - name: {{ dbname }}
    - pkg: python-mysqldb
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_user:
    - present
    - host: localhost
    - name: {{ dbuser }}
    - password: {{ dbuserpass }}
    - require:
      - service: mysql-server
      - pkg: python-mysqldb
  mysql_grants:
    - present
    - grant: all privileges
    - user: {{ dbuser }}
    - database: {{ dbname }}.*
    - host: localhost
    - require:
      - mysql_user: wordpress
      - mysql_database: wordpress

wordpress_uwsgi:
  file:
    - managed
    - name: /etc/uwsgi/wordpress.yml
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - source: salt://uwsgi/template.jinja2
    - template: jinja
    - context:
        dir: {{ wordpressdir }}
        chdir: {{ wordpressdir }}
        appname: wordpress
    - require:
      - module: wordpress_initial
      - service: uwsgi
      - service: mysql-server
      - file: {{ wordpressdir }}/wp-config.php
      - archive: wordpress
      - pkg: php5-mysql
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/wordpress.yml
    - require:
      - file: /etc/uwsgi/wordpress.yml
    - watch:
      - file: wordpress_uwsgi
      - file: {{ wordpressdir }}/wp-config.php
      - archive: wordpress

{{ wordpressdir }}/wp-content/uploads:
  file:
    - symlink
    - target: /var/lib/deployments/wordpress/upload
    - makedirs: True
    - mode: 750
    - user: www-data
    - group: www-data
    - require:
      - archive: wordpress
      - file: /var/lib/deployments/wordpress/upload

{{ wordpressdir }}/wp-config.php:
  file:
    - managed
    - name: {{ wordpressdir }}/wp-config.php
    - template: jinja
    - source: salt://wordpress/config.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - archive: wordpress
      - user: web
    - context:
      dbuserpass: {{ dbuserpass }}
      dbname: {{ dbname }}
      dbuser: {{ dbuser }}
      ssl: {{ ssl }}

php5-mysql:
  pkg:
    - installed
    - require:
      - pkg: php-dev

wordpress_initial:
  file:
    - managed
    - name: {{ wordpressdir }}/wp-admin/init.php
    - source: salt://wordpress/init.jinja2
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - archive: wordpress
      - user: web
  cmd:
    - wait
    - name: php init.php 2>/dev/null
    - cwd: {{ wordpressdir }}/wp-admin
    - user: www-data
    - require:
      - pkg: php-dev
      - pkg: php5-mysql
      - user: web
      - mysql_grants: wordpress
      - file: wordpress_initial
      - file: {{ wordpressdir }}/wp-config.php
    - watch:
      - mysql_database: wordpress
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
    - user: root
    - group: www-data
    - mode: 440
    - template: jinja
    - require:
      - pkg: nginx
      - module: wordpress_uwsgi
    - watch_in:
      - service: nginx
    - context:
        appname: wordpress
        root: {{ wordpressdir }}

/etc/logrotate.d/wordpress:
  file:
    - managed
    - source: salt://wordpress/logrotate.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: logrotate
    - context:
      web_dir: {{ wordpressdir }}

/var/lib/deployments/wordpress/upload:
  file:
    - directory
    - user: www-data
    - group: www-data
    - mode: 750
    - makedirs: True
    - require:
      - user: web

{%- if ssl %}
extend:
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
