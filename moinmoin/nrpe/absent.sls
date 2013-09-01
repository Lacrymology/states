{#
 Remove Nagios NRPE check for moinmoin
#}
/etc/nagios/nrpe.d/moinmoin.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/moinmoin-nginx.cfg:
  file:
    - absent
