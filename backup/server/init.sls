{#-
Backup Server
=============

Install poor man backup server used for rsync and scp to store files.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

shinken_pollers:
  - 192.168.1.1

shinken_pollers: IP address of monitoring poller that check this server.
    Default: not used.
-#}
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
{%- if 'files_archive' in pillar %}
    - no_index: True
    - find_links: {{ pillar['files_archive'] }}/pip/
{%- endif %}
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
