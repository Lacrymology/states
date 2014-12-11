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
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - bash
  - cron
  - local
  - rsyslog

clamav-freshclam:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  user:
    - present
    - name: clamav
    - shell: /bin/false
    - require:
      - pkg: clamav-freshclam
  module:
    - wait
    - name: service.stop
    - m_name: clamav-freshclam
    - watch:
      - pkg: clamav-freshclam
  cmd:
    - wait
    - name: freshclam --stdout -v
    - require:
      - file: clamav-freshclam
      - module: clamav-freshclam
    - watch:
      - pkg: clamav-freshclam
      - user: clamav-freshclam
  file:
    - managed
    - name: /etc/clamav/freshclam.conf
    - source: salt://clamav/freshclam.jinja2
    - template: jinja
    - mode: 444
    - user: clamav
    - group: clamav
    - require:
      - pkg: clamav-freshclam
  service:
    - running
    - order: 50
    - require:
      - cmd: clamav-freshclam
    - watch:
      - file: clamav-freshclam
      - pkg: clamav-freshclam
      - user: clamav-freshclam

clamav-daemon:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
      - pkg: clamav-freshclam
  file:
    - managed
    - name: /etc/clamav/clamd.conf
    - source: salt://clamav/clamd.jinja2
    - template: jinja
    - mode: 400
    - user: clamav
    - group: clamav
    - require:
      - pkg: clamav-daemon
  service:
    - running
    - order: 50
    - require:
      - service: clamav-freshclam
    - watch:
      - pkg: clamav-daemon
      - file: clamav-daemon
      - user: clamav-freshclam

{%- if salt['pillar.get']('clamav:daily_scan', False) %}
/usr/local/bin/clamav-scan.sh:
  file:
    - managed
    - source: salt://clamav/scan.sh
    - user: root
    - group: root
    - mode: 500
    - require:
      - file: bash
      - file: /usr/local
      - service: clamav-freshclam

/etc/cron.daily/clamav_scan:
  file:
    - managed
    - source: salt://clamav/cron_daily.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 500
    - require:
      - file: bash
      - file: /usr/local/bin/clamav-scan.sh
      - pkg: cron
{%- endif %}

/var/lib/clamav/last-scan:
  file:
{%- if salt['pillar.get']('clamav:daily_scan', False) %}
    - managed
    - require:
      - service: clamav-freshclam
      - file: /etc/cron.daily/clamav_scan
{%- else %}
   - absent
{%- endif %}

{%- call manage_pid('/var/run/clamav/freshclam.pid', 'clamav', 'clamav', 'clamav-freshclam', 660) %}
- pkg: clamav-freshclam
{%- endcall %}
{%- call manage_pid('/var/run/clamav/clamd.pid', 'clamav', 'clamav', 'clamav-daemon', 664) %}
- pkg: clamav-daemon
{%- endcall %}
