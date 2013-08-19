{#
 Remove Nagios NRPE check for ClamAV
#}
/etc/nagios/nrpe.d/clamav.cfg:
  file:
    - absent
