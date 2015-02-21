{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/cron.d/passive-checks-postgresql.server:
  file:
    - absent

/usr/lib/nagios/plugins/check_pgsql_query.py:
  file:
    - absent
