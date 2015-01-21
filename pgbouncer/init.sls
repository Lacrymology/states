{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
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
      - file: /etc/pgbouncer/userlist.txt
      - file: /etc/default/pgbouncer
      - file: /etc/init.d/pgbouncer

{%- call manage_pid('/var/run/postgresql/pgbouncer.pid', 'postgres', 'postgres', 'pgbouncer') %}
- pkg: pgbouncer
{%- endcall %}

/etc/pgbouncer/userlist.txt:
  file:
    - managed
    - template: jinja
    - user: root
    - group: postgres
    - mode: 440
    - contents: |
        {%- for value in salt['pillar.get']('pgbouncer:databases').itervalues() %}
        "{{ value['username'] }}" "{{ value['password'] }}"
        {%- endfor %}
    - require:
      - pkg: pgbouncer
      - user: postgres

/etc/default/pgbouncer:
  file:
    - managed
    - source: salt://pgbouncer/default.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
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
