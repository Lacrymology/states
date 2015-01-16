{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/cron.d/passive-checks-postgresql.server:
  file:
    - absent

{{ opts['cachedir'] }}/pip/postgresql.server.nrpe:
  file:
    - absent
