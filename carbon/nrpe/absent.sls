{#
 Remove Nagios NRPE check for Carbon
#}
/etc/nagios/nrpe.d/carbon.cfg:
  file:
    - absent
