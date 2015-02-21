{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - cron
  - postgresql.server.backup

backup-sentry:
  file:
    - managed
    - name: /etc/cron.daily/backup-sentry
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://sentry/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql
      - file: bash
