{#-
Copyright (c) 2013, Hung Nguyen Viet
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

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
include:
  - apt

{#- PID file owned by root, no need to manage #}
rsyslog:
  pkgrepo:
    - managed
{%- if 'files_archive' in pillar %}
    - name: deb {{ pillar['files_archive']|replace('https://', 'http://') }}/mirror/rsyslog/7.4.4 {{ grains['lsb_distrib_codename'] }} main
    - key_url: salt://rsyslog/key.gpg
{%- else %}
    - ppa: tmortensen/rsyslogv7
{%- endif %}
    - file: /etc/apt/sources.list.d/rsyslogv7.list
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - version: 7.4.4-0ubuntu1ppa1
    - require:
      - cmd: apt_sources
      - pkg: gsyslogd
      - pkgrepo: rsyslog
  user:
    - present
    - name: syslog
    - shell: /bin/false
    - require:
      - pkg: rsyslog
      - pkgrepo: rsyslog
  file:
    - managed
    - name: /etc/rsyslog.conf
    - mode: 440
    - template: jinja
    - source: salt://rsyslog/config.jinja2
    - require:
      - pkg: rsyslog
  service:
    - running
    - order: 50
    - watch:
      - pkg: rsyslog
      - file: rsyslog
      - file: /var/spool/rsyslog
      - user: rsyslog
      - file: /var/log/lastlog

/var/log/lastlog:
  file:
    - managed
    - user: root
    - group: utmp
    - mode: 660

/var/spool/rsyslog:
  file:
    - directory
    - mode: 755
    - user: syslog
    - require:
      - pkg: rsyslog

gsyslogd:
  service:
    - dead
  file:
    - absent
    - name: /etc/init/gsyslogd.conf
    - require:
      - service: gsyslogd
  pkg:
    - purged
    - pkgs:
      - klogd
      - syslogd
    - require:
      - service: gsyslogd

{%- for filename in ('/usr/local/gsyslog', '/etc/gsyslog.d', '/etc/gsyslogd.conf') %}
{{ filename }}:
  file:
    - absent
    - require:
      - file: gsyslogd
{%- endfor %}

/etc/rsyslog.d/50-default.conf:
  file:
    - absent
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

/etc/rsyslog.d/20-ufw.conf:
  file:
    - absent
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

/etc/logrotate.d/rsyslog:
  file:
    - managed
    - template: jinja
    - source: salt://rsyslog/logrotate.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: rsyslog
