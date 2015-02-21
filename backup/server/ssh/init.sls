{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
