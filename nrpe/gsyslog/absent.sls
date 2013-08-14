{#
 Remove Gsyslog configuration for Nagios NRPE
#}
/etc/gsyslog.d/nrpe.conf:
  file:
    - absent
