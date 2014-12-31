{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>

Backup GitLab
-#}
include:
  - backup.client
  - bash
  - cron
  - sudo

{%- set version = '7.3.2' %}

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
