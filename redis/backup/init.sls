{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - cron
  - backup.client

backup-redis:
  file:
    - managed
    - name: /etc/cron.daily/backup-redis
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://redis/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-file
      - file: bash
