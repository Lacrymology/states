{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client
  - bash
  - cron

backup-geminabox:
  file:
    - managed
    - name: /etc/cron.daily/backup-geminabox
    - template: jinja
    - source: salt://geminabox/backup/cron.jinja2
    - user: root
    - group: root
    - mode: 500
    - require:
      - file: /usr/local/bin/backup-file
      - file: /usr/local/share/salt_common.sh
      - file: bash
      - pkg: cron
