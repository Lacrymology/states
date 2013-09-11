{#
 Remove rsyslog configuration for Nagios NRPE
#}
/etc/rsyslog.d/nrpe.conf:
  file:
    - absent
