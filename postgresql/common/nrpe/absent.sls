{#
 Remove Nagios NRPE check for PostgreSQL Server
#}
/etc/nagios/nrpe.d/postgresql-monitoring.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - absent
