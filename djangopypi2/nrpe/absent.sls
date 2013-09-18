{#
 Remove Nagios NRPE check for djangopypi2
#}
/etc/nagios/nrpe.d/djangopypi2.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/djangopypi2-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-djangopypi2.cfg:
  file:
    - absent
