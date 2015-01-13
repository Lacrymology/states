{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

{#- PID file owned by root, no need to manage #}
rsyslog:
  pkgrepo:
    - managed
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/rsyslog/7.4.4 {{ grains['lsb_distrib_codename'] }} main
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
