{#
 Remove Nagios NRPE check for ProFTPd
#}
/etc/nagios/nrpe.d/proftpd.cfg:
  file:
    - absent
