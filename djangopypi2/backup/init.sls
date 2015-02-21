{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - cron
  - postgresql.server.backup
  - backup.client

backup-djangopypi2:
  file:
    - managed
    - name: /etc/cron.daily/backup-djangopypi2
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://djangopypi2/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql
      - file: /usr/local/bin/backup-file
      - file: bash
