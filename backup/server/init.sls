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

Author: Bruno Clermont patate@fastmail.cn
Maintainer: Bruno Clermont patate@fastmail.cn
 
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
  - rsyslog

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
      - service: rsyslog
