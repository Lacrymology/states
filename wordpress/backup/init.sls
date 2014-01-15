{#-
 Backup for Wordpress
#}
include:
  - cron
  - mariadb.server.backup
  - backup

{%- set wordpressdir = "/usr/local/wordpress" %}

/etc/cron.daily/backup-wordpress:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://wordpress/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-mysql
      - file: /usr/local/bin/backup-file
    - context:
      wordpressdir: {{ wordpressdir }}
