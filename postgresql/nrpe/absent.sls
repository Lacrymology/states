{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

nrpe_check_pgsql_query:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/postgresql.nrpe

/usr/lib/nagios/plugins/check_pgsql_query.py:
  file:
    - absent
