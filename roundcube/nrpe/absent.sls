{#
 Remove roundcube web Nagios NRPE checks
#}
/etc/nagios/nrpe.d/roundcube.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-roundcube.cfg:
  file:
    - absent
