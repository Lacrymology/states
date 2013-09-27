{#-
 Backup for Wordpress
#}
include:
  - cron

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
    - context:
      wordpressdir: {{ wordpressdir }}
