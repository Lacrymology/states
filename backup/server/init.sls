{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Install poor man backup server used for rsync and scp to store files.
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

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/backup-requirements.txt:
  file:
    - absent

backup-archiver-dependency:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/backup.server
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/server/requirements.jinja2
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/backup.server
    - watch:
      - file: backup-archiver-dependency

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
      - service: rsyslog
      - module: pysc
