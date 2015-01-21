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

/usr/lib/nagios/plugins/check_pgsql_query.py:
  file:
    - managed
    - source: salt://postgresql/server/nrpe/check_pgsql_query.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-pgbouncer
