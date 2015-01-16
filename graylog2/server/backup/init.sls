{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - cron
  - mongodb.backup

backup-graylog2:
  file:
    - managed
    - name: /etc/cron.daily/backup-graylog2
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://graylog2/server/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-mongodb
      - file: bash
