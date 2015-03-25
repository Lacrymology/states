{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-
-#}

/etc/nagios/nrpe.d/postgresql-diamond.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('postgresql.common') }}

/usr/lib/nagios/plugins/check_psql_encoding.py:
  file:
    - absent

/etc/sudoers.d/nrpe_postgresql_common:
  file:
    - absent

/usr/local/nagios/src/check_postgres-2.21.0:
  file:
    - absent

/usr/lib/nagios/plugins/check_postgres:
  file:
    - absent
