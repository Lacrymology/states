{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - cron

cleanup-old-archive:
  file:
    - managed
    - name: /etc/cron.daily/backup-server-ssh
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://backup/server/ssh/cron.jinja2
    - require:
      - pkg: cron
      - file: bash
