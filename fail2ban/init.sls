{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context %}

{%- set version = '0.8.14' %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}

include:
  - apt
  - local
  - rsyslog
  - virtualenv

/etc/rsyslog.d/fail2ban.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        $RepeatedMsgReduction off
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog

{#- Fail2ban 0.8.6 on precise does not support jail.d
So, install from tarball instead of using native Ubuntu package #}
fail2ban:
  virtualenv:
    - manage
    - name: /usr/local/fail2ban
    - require:
      - module: virtualenv
      - file: /usr/local
  archive:
    - extracted
    - name: /usr/local/fail2ban/src
{%- if files_archive %}
    - source: {{ files_archive }}/pip/fail2ban-{{ version }}.tar.gz
{%- else %}
    - source: https://github.com/fail2ban/fail2ban/archive/{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=a8697d82bab9bbdb99e5c93a76551742
    - if_missing: /usr/local/fail2ban/src/fail2ban-{{ version }}
    - archive_format: tar
    - tar_options: z
    - require:
      - file: /usr/local/fail2ban/src
  cmd:
    - wait
    - cwd: /usr/local/fail2ban/src/fail2ban-{{ version }}
    - name: /usr/local/fail2ban/bin/python setup.py install --install-scripts=/usr/bin --record=/usr/local/fail2ban/install.log
    - watch:
      - archive: fail2ban
  file:
    - managed
    - name: /etc/fail2ban/fail2ban.conf
    - source: salt://fail2ban/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - cmd: fail2ban
  service:
    - running
    - watch:
      - file: fail2ban
      - file: /etc/init.d/fail2ban

/usr/local/fail2ban/src:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - require:
      - virtualenv: fail2ban

/etc/init.d/fail2ban:
  file:
    - managed
    - source: salt://fail2ban/sysvinit.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - require:
      - cmd: fail2ban

{%- for suffix in ('conf', 'local') %}
/etc/fail2ban/jail.{{ suffix }}:
  file:
    - managed
    - source: salt://fail2ban/jail_{{ suffix }}.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - cmd: fail2ban
    - watch_in:
      - service: fail2ban
{%- endfor %}

{%- call manage_pid('/var/run/fail2ban/fail2ban.pid', 'root', 'root', 'fail2ban', 600) %}
- cmd: fail2ban
{%- endcall %}
