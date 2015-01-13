{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - cron
  - postgresql.server.backup

backup-proftpd:
  file:
    - managed
    - name: /etc/cron.daily/backup-proftpd
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://proftpd/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql
      - file: bash
