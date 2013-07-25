{#
 Remove pDNSd Nagios NRPE checks
 #}
/etc/nagios/nrpe.d/pdnsd.cfg:
  file:
    - absent
