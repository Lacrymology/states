{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client
  - bash
  - cron
  - sudo

{%- set version = '8.1.4' %}

backup-gitlab:
  file:
    - managed
    - name: /etc/cron.daily/backup-gitlab
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://gitlab/backup/cron.jinja2
    - context:
        version: {{ version }}
    - require:
      - pkg: cron
      - pkg: sudo
      - file: /usr/local/bin/backup-file
      - file: bash
      - file: /usr/local/share/salt_common.sh
