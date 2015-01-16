{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - cron
  - backup.client

backup-postfix:
  file:
    - managed
    - name: /etc/cron.daily/backup-postfix
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://postfix/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-file
      - file: bash
