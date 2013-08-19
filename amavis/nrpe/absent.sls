{#
 Remove Nagios NRPE check for Amavis
#}
/etc/nagios/nrpe.d/amavis.cfg:
  file:
    - absent
