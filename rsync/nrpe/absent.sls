{#
 Remove Nagios NRPE check for Rsync
#}
/etc/nagios/nrpe.d/rsync.cfg:
  file:
    - absent
