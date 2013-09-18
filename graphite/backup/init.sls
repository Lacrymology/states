{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Backup client for Graphite
 -#}
include:
  - cron

/etc/cron.daily/backup-graphite:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://graphite/backup/cron.jinja2
    - require:
      - pkg: cron
