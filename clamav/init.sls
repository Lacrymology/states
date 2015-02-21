{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
  module:
    - wait
    - name: service.stop
    - m_name: clamav-freshclam
    - watch:
      - pkg: clamav-freshclam
  cmd:
    - wait
{#- on the very first run, it may say it cannot notify clamd, it's normal,
    because clamd cannot run without a db, which is provided by running this cmd #}
    - name: freshclam --stdout -v
    - require:
      - file: clamav-freshclam
      - module: clamav-freshclam
    - watch:
      - pkg: clamav-freshclam
      - user: clamav
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
      - user: clamav

clamav:
  user:
    - present
    - name: clamav
    - shell: /bin/false
    - require:
      - pkg: clamav-freshclam

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
      - user: clamav

/usr/local/bin/clamav-scan.sh:
  file:
{%- set daily_scan = salt['pillar.get']('clamav:daily_scan', False) %}
{%- if daily_scan %}
    - managed
    - source: salt://clamav/scan.sh
    - user: root
    - group: root
    - mode: 500
    - require:
      - file: bash
      - file: /usr/local
      - service: clamav-freshclam
{%- else %}
    - absent
{%- endif %}


/etc/cron.daily/clamav_scan:
  file:
{%- if daily_scan %}
    - symlink
    - target: /usr/local/bin/clamav-scan.sh
    - user: root
    - group: root
    - mode: 500
    - require:
      - file: /usr/local/bin/clamav-scan.sh
      - pkg: cron
{%- else %}
    - absent
{%- endif %}

/var/lib/clamav/last-scan:
  file:
{%- if daily_scan %}
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
