{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}
rsyslog:
  pkg:
    - purged
    - require:
      - service: rsyslog
  file:
    - absent
    - name: /etc/rsyslog.conf
    - require:
      - pkg: rsyslog
  service:
    - dead
{%- if os.is_precise %}
  cmd:
    - run
    - name: 'apt-key del 431533D8'
    - onlyif: apt-key list | grep -q 431533D8
  pkgrepo:
    - absent
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - name: deb {{ files_archive|replace('https://', 'http://') }}/mirror/rsyslog/7.4.4 {{ grains['lsb_distrib_codename'] }} main
{%- else %}
    - name: deb http://archive.robotinfra.com/mirror/rsyslog/7.4.4 {{ grains['lsb_distrib_codename'] }} main
{%- endif %}

/etc/apt/sources.list.d/tmortensen-rsyslogv7-{{ grains['oscodename'] }}.list:
  file:
    - absent
    - require:
      - pkgrepo: rsyslog
{%- endif %}

/etc/rsyslog.d:
  file:
    - absent
    - require:
      - service: rsyslog

{%- if os.is_precise %}
/etc/apt/sources.list.d/rsyslogv7.list:
  file:
    - absent
{%- endif %}

/var/spool/rsyslog:
  file:
    - absent
    - require:
      - pkg: rsyslog

/var/log/lastlog:
  file:
    - absent
    - require:
      - pkg: rsyslog

rsyslog_absent_mail_logs:
  cmd:
    - run
    - name: rm -f /var/log/mail.*
    - require:
      - service: rsyslog
