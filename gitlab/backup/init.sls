{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Backup for Gitlab
 -#}
include:
  - cron

/etc/cron.daily/backup-gitlab:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://gitlab/backup/cron.jinja2
    - require:
      - pkg: cron
