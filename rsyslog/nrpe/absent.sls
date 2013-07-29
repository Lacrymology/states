{#
 Remove Nagios NRPE check for rsyslog
#}
/etc/nagios/nrpe.d/rsyslog.cfg:
  file:
    - absent
