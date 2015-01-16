{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - cron
  - postgresql.server.backup

backup-openerp:
  file:
    - managed
    - name: /etc/cron.daily/backup-openerp
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://openerp/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql-by-role
      - file: bash
