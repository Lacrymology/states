{#
 Remove Nagios NRPE check for PostgreSQL Server
#}
/etc/nagios/nrpe.d/postgresql-diamond.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql.cfg:
  file:
    - absent
