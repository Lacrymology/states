{#
 Install poor man backup server used for rsync and scp to store files.
#}
include:
  - apt
  - ssh.server
  - pip
  - cron
  - gsyslog

backup-server:
  pkg:
    - installed
    - name: rsync
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

backup-archiver-dependency:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/backup-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/server/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/backup-requirements.txt
    - watch:
      - file: backup-archiver-dependency
    - require:
      - module: pip

/etc/backup-archive.conf:
  file:
    - managed
    - template: jinja
    - source: salt://backup/server/config.jinja2
    - mode: 500
    - user: root
    - group: root

/etc/cron.weekly/backup-archiver:
  file:
    - managed
    - source: salt://backup/server/archive.py
    - mode: 500
    - user: root
    - group: root
    - require:
      - module: backup-archiver-dependency
      - pkg: cron
      - service: gsyslog
