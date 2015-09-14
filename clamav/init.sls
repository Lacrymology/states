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
    - mode: 440
    - user: root
    - group: clamav
    - require:
      - pkg: clamav-daemon

clamav:
  user:
    - present
    - name: clamav
    - shell: /bin/false
    - require:
      - pkg: clamav-daemon

/usr/local/bin/clamav-scan.sh:
  file:
{%- set daily_scan = salt['pillar.get']('clamav:daily_scan', False) %}
{%- if daily_scan %}
    - managed
    - source: salt://clamav/scan.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 500
    - require:
      - file: bash
      - file: /usr/local
{%- else %}
    - absent
{%- endif %}

/etc/cron.daily/zz_clamav_scan:
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
    - user: clamav
    - group: clamav
    - mode: 640
    - replace: False
    - require:
      - file: /etc/cron.daily/zz_clamav_scan
{%- else %}
   - absent
{%- endif %}
