{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

{%- from "os.jinja2" import os with context %}

{#- PID file owned by root, no need to manage #}
rsyslog:
{%- if os.is_precise %}
  pkgrepo:
    - managed
  {%- set files_archive = salt['pillar.get']('files_archive', False) %}
  {%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/rsyslog/7.4.4 {{ grains['lsb_distrib_codename'] }} main
  {%- else %}
    {#- source: ppa: tmortensen/rsyslogv7 #}
    - name: deb http://archive.robotinfra.com/mirror/rsyslog/7.4.4 {{ grains['lsb_distrib_codename'] }} main
  {%- endif %}
    - key_url: salt://rsyslog/key.gpg
    - file: /etc/apt/sources.list.d/rsyslogv7.list
    - clean_file: True
    - require:
      - pkg: apt_sources
    - require_in:
      - pkg: rsyslog
{%- endif %}
  pkg:
    - installed
{%- if os.is_precise %}
    - version: 7.4.4-0ubuntu1ppa1
{%- endif %}
    - require:
      - cmd: apt_sources
  user:
    - present
    - name: syslog
    - shell: /bin/false
    - require:
      - pkg: rsyslog
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
