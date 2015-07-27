{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client
  - bash
  - cron
  - influxdb

/var/lib/influxdb/backup:
  file:
    - directory
    - user: influxdb
    - group: influxdb
    - mode: 755
    - require:
      - file: /var/lib/influxdb

backup-influxdb:
  file:
    - managed
    - name: /etc/cron.daily/backup-influxdb
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://influxdb/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-file
      - file: bash
      - file: /usr/local/share/salt_common.sh
      - file: /var/lib/influxdb/backup
