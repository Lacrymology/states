{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
