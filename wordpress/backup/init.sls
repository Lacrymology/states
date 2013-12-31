{#-
 Backup for Wordpress
#}
include:
  - cron
  - postgresql.server.backup
  - backup.client

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
      - file: /usr/local/bin/backup-postgresql
      - file: /usr/local/bin/backup_store
    - context:
      wordpressdir: {{ wordpressdir }}
