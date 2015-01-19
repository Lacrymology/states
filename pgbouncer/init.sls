{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - postgresql.server
  - rsyslog

pgbouncer:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  user:
    - present
    - name: pgbouncer
    - shell: /usr/sbin/nologin
    - require:
      - pkg: pgbouncer
  file:
    - managed
    - name: /etc/pgbouncer/pgbouncer.ini
    - source: salt://pgbouncer/config.jinja2
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 440
    - require:
      - pkg: pgbouncer
      - user: pgbouncer
  service:
    - running
    - enable: True
    - order: 50
    - name: pgbouncer
    - require:
      - service: rsyslog
    - watch:
      - user: pgbouncer
      - pkg: pgbouncer
      - file: pgbouncer
      - file: /etc/pgbouncer/userlist.txt

{%- call manage_pid('/var/run/postgresql/pgbouncer.pid', 'postgres', 'postgres', 'pgbouncer') %}
- pkg: pgbouncer
{%- endcall %}

/etc/pgbouncer/userlist.txt:
  file:
    - managed
    - source: salt://pgbouncer/userlist.jinja2
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 440
    - require:
      - pkg: pgbouncer
      - user: pgbouncer

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
