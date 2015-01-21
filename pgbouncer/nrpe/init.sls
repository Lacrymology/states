{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - postgresql.nrpe
  - rsyslog.nrpe
  - sudo

{{ passive_check('pgbouncer') }}

/etc/sudoers.d/nrpe_pgbouncer:
  file:
    - managed
    - source: salt://pgbouncer/nrpe/sudo.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: sudo

pgbouncer_nrpe_check_pgsql_query:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/pgbouncer.nrpe
    - user: root
    - group: root
    - mode: 440
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}
        psycopg2==2.4.5
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: {{ opts['cachedir'] }}/pip/pgbouncer.nrpe
    - watch:
      - file: pgbouncer_nrpe_check_pgsql_query

/usr/lib/nagios/plugins/check_pgsql_query.py:
  file:
    - managed
    - source: salt://postgresql/server/nrpe/check_pgsql_query.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - module: pgbouncer_nrpe_check_pgsql_query
      - pkg: nagios-nrpe-server
      - file: nsca-pgbouncer
