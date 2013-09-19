{#-
Copyright (c) 2013, <BRUNO CLERMONT>
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

CRON Daemon
===========

Install daemon to execute scheduled commands (Vixie Cron).

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

crontab_hour: 6
shinken_pollers:
  - 192.168.1.1

crontab_hour: Each days cron launch a daily group of tasks, they are located
    in /etc/cron.daily/. This is the time of the day when they're executed.
    Default: 6 hours in the morning, local time.
shinken_pollers: IP address of monitoring poller that check this server.
    Default: not used.
-#}

include:
  - apt
  - rsyslog

cron:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/crontab
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://cron/crontab.jinja2
    - require:
      - pkg: cron
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
    - watch:
      - pkg: cron
      - file: /etc/crontab
