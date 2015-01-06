{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - cron
  - pip
  - pysc
  - rsyslog
  - ssh.server

backup-server:
  pkg:
    - installed
    - name: rsync
{#- this does not include rsync formula as this only need rsync installed, not run rsyncd #}
    - required:
      - pkg: openssh-server
      - service: openssh-server
      - cmd: apt_sources
  file:
    - directory
    - name: /var/lib/backup
    - user: root
    - group: root
    - mode: 775
    - require:
      - pkg: backup-server

backup-archiver-dependency:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/backup.server

/etc/backup-archive.conf:
  file:
    - absent

/etc/cron.weekly/backup-archiver:
  file:
    - managed
    - source: salt://backup/server/archive.py
    - mode: 500
    - user: root
    - group: root
    - require:
      - module: pysc
      - pkg: cron
      - service: rsyslog
      - module: pysc
