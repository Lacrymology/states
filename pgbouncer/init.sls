{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - postgresql
  - rsyslog

pgbouncer:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/pgbouncer/pgbouncer.ini
    - source: salt://pgbouncer/config.jinja2
    - template: jinja
    - user: root
    - group: postgres
    - mode: 440
    - show_diff: False
    - require:
      - pkg: pgbouncer
      - user: postgres
  service:
    - running
    - enable: True
    - require:
      - service: rsyslog
    - watch:
      - user: postgres
      - pkg: pgbouncer
      - file: pgbouncer
      - file: /etc/default/pgbouncer
      - file: /etc/init.d/pgbouncer

{%- call manage_pid('/var/run/postgresql/pgbouncer.pid', 'postgres', 'postgres', 'pgbouncer') %}
- pkg: pgbouncer
{%- endcall %}

/etc/pgbouncer/userlist.txt:
  file:
{%- if salt['pillar.get']('pgbouncer:auth_type', 'md5') != 'any' %}
    - managed
    - source: salt://pgbouncer/userlist.jinja2
    - template: jinja
    - user: root
    - group: postgres
    - mode: 440
    - require:
      - pkg: pgbouncer
      - user: postgres
    - watch_in:
      - service: pgbouncer
{%- else %}
    - absent
{%- endif %}

/etc/default/pgbouncer:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}
        START=1
    - require:
      - pkg: pgbouncer

/etc/init.d/pgbouncer:
  file:
    - managed
    - source: salt://pgbouncer/sysvinit.jinja2
    - user: root
    - group: root
    - mode: 550
    - require:
      - pkg: pgbouncer
