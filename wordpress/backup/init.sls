{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - cron
  - mysql.server.backup

backup-wordpress:
  file:
    - managed
    - name: /etc/cron.daily/backup-wordpress
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://wordpress/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-mysql
      - file: /usr/local/bin/backup-file
      - file: bash
