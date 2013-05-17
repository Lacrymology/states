{#
 Remove Nagios NRPE check for Gsyslog
#}
/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - absent
