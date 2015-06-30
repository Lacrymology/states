{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - cron
  - backup.client

backup-openvpn:
  file:
    - managed
    - name: /etc/cron.daily/backup-openvpn
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://openvpn/server/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-file
      - file: bash
