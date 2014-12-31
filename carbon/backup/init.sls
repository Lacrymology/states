{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - bash
  - cron
  - backup.client

backup-carbon:
  file:
    - managed
    - name: /etc/cron.daily/backup-carbon
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://carbon/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-file
      - file: bash
